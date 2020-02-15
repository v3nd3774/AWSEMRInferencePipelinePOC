locals {
  uriprefix = "http://yann.lecun.com/exdb/mnist/"
  script = "${dirname(dirname(path.module))}/py/download-data.py"
  projprefix = "AWSEMRInferencePipelinePOC"
}
locals {
  bucketname = "${local.projprefix}_Source"
  filename1 = "${local.uriprefix}train-images-idx3-ubyte.gz"
  filename2 = "${local.uriprefix}train-labels-idx1-ubyte.gz"
  filename3 = "${local.uriprefix}t10k-images-idx3-ubyte.gz"
  filename4 = "${local.uriprefix}t10k-labels-idx1-ubyte.gz"
  tags = {
    Project = local.projprefix
  }
}

resource "aws_s3_bucket" "source" {
  bucket = local.bucketname
  acl    = "private"
  tags = local.tags
}

data "external" "downloadmnist1" {
  program = ["python", local.script]
  query = {
    uri = local.filename1
  }
}
data "external" "downloadmnist2" {
  program = ["python", local.script]
  query = {
    uri = local.filename2
  }
}
data "external" "downloadmnist3" {
  program = ["python", local.script]
  query = {
    uri = local.filename3
  }
}
data "external" "downloadmnist4" {
  program = ["python", local.script]
  query = {
    uri = local.filename4
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = local.bucketname
  key    = "${basename(data.external.downloadmnist1.result)}"
  source = "${data.external.downloadmnist1.result}"
  etag = "${filemd5(data.external.downloadmnist1.result)}"
  tags = local.tags
}

resource "aws_s3_bucket_object" "object" {
  bucket = local.bucketname
  key    = "${basename(data.external.downloadmnist2.result)}"
  source = "${data.external.downloadmnist2.result}"
  etag = "${filemd5(data.external.downloadmnist2.result)}"
  tags = local.tags
}

resource "aws_s3_bucket_object" "object" {
  bucket = local.bucketname
  key    = "${basename(data.external.downloadmnist3.result)}"
  source = "${data.external.downloadmnist3.result}"
  etag = "${filemd5(data.external.downloadmnist3.result)}"
  tags = local.tags
}

resource "aws_s3_bucket_object" "object" {
  bucket = local.bucketname
  key    = "${basename(data.external.downloadmnist4.result)}"
  source = "${data.external.downloadmnist4.result}"
  etag = "${filemd5(data.external.downloadmnist4.result)}"
  tags = local.tags
}
