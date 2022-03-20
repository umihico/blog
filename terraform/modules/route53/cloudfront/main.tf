terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = var.vars.route53.route53_zone.zone_id
  name    = var.vars.domain
  type    = "A"
  alias {
    name                   = var.vars.cloudfront_distribution.domain_name
    zone_id                = var.vars.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
