# imports
# no modules yet

# From: https://github.com/azavea/terraform-aws-emr-cluster/blob/develop/main.tf originally by Azavea: https://github.com/azavea
# EMR IAM resources
#
data "aws_iam_policy_document" "emr_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr_service_role" {
  name               = "emr${var.environment}ServiceRole"
  assume_role_policy = data.aws_iam_policy_document.emr_assume_role.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "emr_service_role" {
  role       = aws_iam_role.emr_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

#
# EMR IAM resources for EC2
#
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr_ec2_instance_profile" {
  name               = "${var.environment}JobFlowInstanceProfile"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "emr_ec2_instance_profile" {
  role       = aws_iam_role.emr_ec2_instance_profile.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_instance_profile" "emr_ec2_instance_profile" {
  name = aws_iam_role.emr_ec2_instance_profile.name
  role = aws_iam_role.emr_ec2_instance_profile.name
}

#
# Security group resources
#
resource "aws_security_group" "emr_master" {
  vpc_id                 = aws_vpc.emr.id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name = "sgMaster"
  })
}

resource "aws_security_group" "emr_slave" {
  vpc_id                 = aws_vpc.emr.id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name = "sgSlave"
  })
}

#
# EMR resources
#
# from https://github.com/terraform-providers/terraform-provider-aws/issues/1530 by n-my
data "template_file" "emr_config" {
  template = <<EOF
[
  {
     "classification":"emrfs-site",
     "properties":{
        "fs.s3.consistent.retryPeriodSeconds":"10",
        "fs.s3.consistent":"true",
        "fs.s3.consistent.retryCount":"5",
        "fs.s3.consistent.metadata.read.capacity":"600",
        "fs.s3.consistent.metadata.write.capacity":"300",
        "fs.s3.consistent.metadata.tableName":"EmrFSMetadata"
     },
     "configurations":[
     ]
  }
]
EOF
}

resource "aws_emr_cluster" "cluster" {
  name           = var.projprefix
  release_label  = var.release_label
  applications   = var.applications
  configurations = data.template_file.emr_config.rendered

  ec2_attributes {
    key_name                          = var.key_name
    subnet_id                         = aws_subnet.emr.id
    emr_managed_master_security_group = aws_security_group.emr_master.id
    emr_managed_slave_security_group  = aws_security_group.emr_slave.id
    instance_profile                  = aws_iam_instance_profile.emr_ec2_instance_profile.arn
  }

  master_instance_group {
    instance_type  = "m3.xlarge"
    instance_count = 1
    ebs_config {
      size = "8"
      type = "gp2"
      volumes_per_instance = 1
    }
  }
  core_instance_group {
    instance_type  = "m3.xlarge"
    instance_count = "1"
    bid_price      = "0.30"
    ebs_config {
      size = "8"
      type = "gp2"
      volumes_per_instance = 1
    }
  }

  bootstrap_action {
    path = "s3://${aws_s3_bucket.emr_bootstrap_bucket.bucket}${aws_s3_bucket_object.bootstrap.key}"
    name = "Install Dependencies on EMR Cluster"
    args = var.bootstrap_args
  }

  log_uri      = "s3n://${aws_s3_bucket.emr_logging_bucket.bucket}"
  service_role = aws_iam_role.emr_service_role.arn

  tags = var.tags
}
