terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.vars.domain
  validation_method = "DNS"
}

module "route53" {
  source = "../../modules/route53/acm"
  providers = {
    aws = aws.parent,
  }
  vars = merge(var.vars, {
    acm = aws_acm_certificate.this
  })
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in module.route53.route53_record_cert_validation : record.fqdn]
}
