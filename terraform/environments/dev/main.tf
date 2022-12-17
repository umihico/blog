terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent, aws.us-east-1]
    }
  }
}

locals {
  parent_vars = jsondecode(var.vars)
  vars = merge(local.parent_vars, {
    prefix     = "dev"
    branch     = "development"
    domain     = local.parent_vars.dev_domain
    basic_auth = true
  })
}
module "base" {
  source = "../base"
  vars   = local.vars
  providers = {
    aws           = aws,
    aws.parent    = aws.parent,
    aws.us-east-1 = aws.us-east-1,
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
