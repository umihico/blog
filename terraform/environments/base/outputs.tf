output "all" {
  value = {
    s3        = module.s3.all
    ecr       = module.ecr.all
    iam       = module.iam.all
    codebuild = module.codebuild.all
  }
}
