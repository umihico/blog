locals {
  private_buckets = toset(["sls-cache", "sls-assets"])
}

resource "aws_s3_bucket" "private_buckets" {
  for_each      = local.private_buckets
  bucket_prefix = "${var.vars.prefix}-${each.value}-"
}

resource "aws_s3_bucket_public_access_block" "private_buckets" {
  for_each                = local.private_buckets
  bucket                  = aws_s3_bucket.private_buckets[each.value].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
