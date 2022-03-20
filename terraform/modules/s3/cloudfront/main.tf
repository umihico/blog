data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      "${var.vars.s3.private_buckets["sls-assets"].arn}/*",
      "${var.vars.s3.private_buckets["sls-assets"].arn}",
    ]

    principals {
      type        = "AWS"
      identifiers = [var.vars.cloudfront_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.vars.s3.private_buckets["sls-assets"].id
  policy = data.aws_iam_policy_document.this.json
}
