terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

locals {
  vars = merge(jsondecode(var.vars), {
    prefix = "dev"
    branch = "development"
  })
}
module "base" {
  source = "../base"
  vars   = local.vars
}

module "ns" {
  source = "../../modules/route53/ns"
  providers = {
    aws        = aws,
    aws.parent = aws.parent,
  }
  vars = local.vars
}
