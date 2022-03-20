terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

locals {
  parent_vars = jsondecode(var.vars)
  vars = merge(local.parent_vars, {
    prefix = "dev"
    branch = "development"
    domain = local.parent_vars.dev_domain
  })
}
module "base" {
  source = "../base"
  vars   = local.vars
  providers = {
    aws        = aws,
    aws.parent = aws.parent,
  }
}

module "ns" {
  source = "../../modules/route53/ns"
  providers = {
    aws        = aws,
    aws.parent = aws.parent,
  }
  vars = local.vars
}
