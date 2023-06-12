output "all" {
  value = {
    s3         = module.s3.all
    route53    = module.route53.all
    acm        = module.acm.all
    acm_usa    = module.acm_usa.all
    cloudfront = module.cloudfront.all
  }
}
