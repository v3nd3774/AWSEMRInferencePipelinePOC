# s3 info for bootstrapscript
locals {
  bootbucketname = lower("${var.projprefix}-EMRBootstrapBucket")
  bootscript = "${dirname(dirname(path.module))}/scripts/bootstrap-emr.sh"
}
resource "aws_s3_bucket" "emr_bootstrap_bucket" {
  bucket = local.bootbucketname
  acl    = "private"
  tags = var.tags
}
resource "aws_s3_bucket_object" "bootstrap" {
  bucket = aws_s3_bucket.emr_bootstrap_bucket.bucket
  key    = "/scripts/bootstrap-emr.sh"
  source = local.bootscript
  etag = filemd5(local.bootscript)
  tags = var.tags
}
