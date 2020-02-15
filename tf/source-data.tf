locals {
  uriprefix = "http://yann.lecun.com/exdb/mnist/"
  script = "${dirname(dirname(path.module))}/py/download-data.py"
  projprefix = "AWSEMRInferencePipelinePOC"
}
locals {
  runscriptcommand = ["python", local.script]
  bucketname = lower("${local.projprefix}-Source")
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
  program = local.runscriptcommand
  query = {
    uri = local.filename1
  }
}
data "external" "downloadmnist2" {
  program = local.runscriptcommand
  query = {
    uri = local.filename2
  }
}
data "external" "downloadmnist3" {
  program = local.runscriptcommand
  query = {
    uri = local.filename3
  }
}
data "external" "downloadmnist4" {
  program = local.runscriptcommand
  query = {
    uri = local.filename4
  }
}

locals {
  source1 = lookup(data.external.downloadmnist1.result, "fpath", "ERRORNOFNAME")
  source2 = lookup(data.external.downloadmnist2.result, "fpath", "ERRORNOFNAME")
  source3 = lookup(data.external.downloadmnist3.result, "fpath", "ERRORNOFNAME")
  source4 = lookup(data.external.downloadmnist4.result, "fpath", "ERRORNOFNAME")
}

resource "aws_s3_bucket_object" "mnist1" {
  bucket = aws_s3_bucket.source.bucket
  key    = basename(local.source1)
  source = local.source1
  etag = filemd5(local.source1)
  tags = local.tags
}

resource "aws_s3_bucket_object" "mnist2" {
  bucket = aws_s3_bucket.source.bucket
  key    = basename(local.source2)
  source = local.source2
  etag = filemd5(local.source2)
  tags = local.tags
}

resource "aws_s3_bucket_object" "mnist3" {
  bucket = aws_s3_bucket.source.bucket
  key    = basename(local.source3)
  source = local.source3
  etag = filemd5(local.source3)
  tags = local.tags
}

resource "aws_s3_bucket_object" "mnist4" {
  bucket = aws_s3_bucket.source.bucket
  key    = basename(local.source4)
  source = local.source4
  etag = filemd5(local.source4)
  tags = local.tags
}
