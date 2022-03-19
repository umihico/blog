output "all" {
  value = {
    s3        = module.s3.all
    iam       = module.iam.all
    codebuild = module.codebuild.all
  }
}
