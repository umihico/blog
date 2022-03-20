terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

data "aws_route53_zone" "this" {
  name     = "${var.vars.domain}."
  provider = aws.parent
}
