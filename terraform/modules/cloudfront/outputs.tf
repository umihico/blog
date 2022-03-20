output "all" {
  value = {
    cloudfront_origin_access_identity = aws_cloudfront_origin_access_identity.this
    cloudfront_distribution           = aws_cloudfront_distribution.this
    s3                                = module.s3.all
    route53                           = module.route53.all
  }
}
