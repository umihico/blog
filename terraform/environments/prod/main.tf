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
    prefix = "prod"
    branch = "main"
    domain = local.parent_vars.prod_domain
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
