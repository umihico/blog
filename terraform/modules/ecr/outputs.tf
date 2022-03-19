output "all" {
  value = {
    codebuild_ecr_repository       = aws_ecr_repository.codebuild
    codebuild_ecr_lifecycle_policy = aws_ecr_lifecycle_policy.codebuild
    codebuild_dockerfile           = data.local_file.codebuild
    codebuild_executor             = null_resource.executor
  }
}
