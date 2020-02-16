# s3 info for logging bucket
locals {
  logbucketname = lower("${var.projprefix}-EMRLoggingBucket")
}
resource "aws_s3_bucket" "emr_logging_bucket" {
  bucket = local.logbucketname
  acl    = "private"
  tags = var.tags
}
