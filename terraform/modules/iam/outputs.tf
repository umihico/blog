output "all" {
  value = {
    oidc_iam_openid_connect_provider = data.aws_iam_openid_connect_provider.github_actions
    oidc_iam_role                    = aws_iam_role.github_actions
  }
}
