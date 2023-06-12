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

# 久しぶりにapplyすると、既存リソースが破壊されていて、新規作成するか聞かれた。既に今もHTTPSに問題はなく、おそらくACMの自動更新によるもの？以下のように消しても問題がない旨のドキュメントがあるので、コメントアウトしておく。
# This resource implements a part of the validation workflow. It does not represent a real-world entity in AWS, therefore changing or deleting this resource on its own has no immediate effect.
# resource "aws_acm_certificate_validation" "this" {
#   certificate_arn         = aws_acm_certificate.this.arn
#   validation_record_fqdns = [for record in module.route53.route53_record_cert_validation : record.fqdn]
# }
