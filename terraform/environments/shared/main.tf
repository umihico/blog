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
    prefix = "shared"
  })
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions" {
  name = "${local.vars.prefix}-github-actions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_actions.arn
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${local.vars.github_repository_owner_name}/${local.vars.github_repository_name}:*"
          ]
        }
      }
    }]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}
