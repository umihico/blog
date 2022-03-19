locals {
  iam       = { iam = module.iam.all }
  codebuild = { codebuild = module.codebuild.all }
  s3        = { s3 = module.s3.all }
  ecr       = { ecr = module.ecr.all }
}
module "iam" {
  source = "../../modules/iam"
  vars   = var.vars
}

module "ecr" {
  source = "../../modules/ecr"
  vars   = var.vars
}

module "codebuild" {
  source = "../../modules/codebuild"
  vars   = merge(var.vars, local.iam, local.s3, local.ecr)
}

module "s3" {
  source = "../../modules/s3"
  vars   = var.vars
}
