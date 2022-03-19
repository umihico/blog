locals {
  iam       = { iam = module.iam.all }
  codebuild = { codebuild = module.codebuild.all }
  s3        = { s3 = module.s3.all }
}
module "iam" {
  source = "../../modules/iam"
  vars   = var.vars
}

module "codebuild" {
  source = "../../modules/codebuild"
  vars   = merge(var.vars, local.iam)
}

module "s3" {
  source = "../../modules/s3"
  vars   = var.vars
}
