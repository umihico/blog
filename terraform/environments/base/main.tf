terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent, aws.us-east-1]
    }
  }
}

locals {
  iam        = { iam = module.iam.all }
  s3         = { s3 = module.s3.all }
  route53    = { route53 = module.route53.all }
  acm        = { acm = module.acm.all }
  cloudfront = { cloudfront = module.cloudfront.all }
  acm_usa    = { acm_usa = module.acm_usa.all }
}

module "route53" {
  source = "../../modules/route53"
  vars   = var.vars
  providers = {
    aws        = aws,
    aws.parent = aws.parent,
  }
}

module "acm" {
  source = "../../modules/acm"
  vars   = var.vars
  providers = {
    aws        = aws,
    aws.parent = aws.parent,
  }
}

module "acm_usa" {
  source = "../../modules/acm"
  vars   = var.vars
  providers = {
    aws        = aws.us-east-1,
    aws.parent = aws.parent,
  }
}

module "iam" {
  source = "../../modules/iam"
  vars   = var.vars
}

module "s3" {
  source = "../../modules/s3"
  vars   = var.vars
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  vars   = merge(var.vars, local.s3, local.acm_usa, local.route53)
  providers = {
    aws        = aws
    aws.parent = aws.parent,
  }
}
