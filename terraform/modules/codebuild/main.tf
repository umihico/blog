resource "aws_codebuild_project" "this" {
  name          = "${var.vars.prefix}-codebuild-project"
  service_role  = var.vars.iam.codebuild.arn
  badge_enabled = true
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "${var.vars.ecr.codebuild_ecr_repository.repository_url}:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"

    dynamic "environment_variable" {
      for_each = {
        "TERRAGRUNT_WORKING_DIR" = "terraform/environments/${var.vars.prefix}"
        "SLS_ASSET_BUCKET"       = var.vars.s3.private_buckets["sls-assets"].bucket
      }
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  source {
    type                = "GITHUB"
    location            = var.vars.source_location
    git_clone_depth     = 1
    report_build_status = true
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
}

resource "aws_codebuild_webhook" "this" {
  # This resource must have authorized CodeBuild to access Bitbucket/GitHub's OAuth API in each applicable region. This is a manual step that must be done before creating webhooks with this resource.
  project_name = aws_codebuild_project.this.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "HEAD_REF"
      pattern = var.vars.branch
    }
  }
}
