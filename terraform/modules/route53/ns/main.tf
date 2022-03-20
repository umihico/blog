terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

data "aws_route53_zone" "prod" {
  name     = "${var.vars.prod_domain}."
  provider = aws.parent
}

data "aws_route53_zone" "dev" {
  name     = "${var.vars.dev_domain}."
  provider = aws.parent
}

resource "aws_route53_record" "ns" {
  allow_overwrite = true
  name            = var.vars.dev_domain
  ttl             = 172800
  type            = "NS"
  zone_id         = data.aws_route53_zone.prod.zone_id
  records         = data.aws_route53_zone.dev.name_servers
  provider        = aws.parent
}
