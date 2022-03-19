resource "aws_codebuild_project" "this" {
  name          = "${var.vars.prefix}-codebuild-project"
  service_role  = var.vars.iam.codebuild.arn
  badge_enabled = true
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "alpine/terragrunt:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TERRAGRUNT_WORKING_DIR"
      value = "terraform/environments/${var.vars.prefix}"
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
