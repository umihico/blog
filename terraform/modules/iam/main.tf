
# 環境ごと（dev,prod）に作れず、共通のものしか作れないため、aws cliで作成して、data sourceで取得する

# オリジナル
# resource "aws_iam_openid_connect_provider" "github_actions" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
# }

# コマンド
# https://aws.amazon.com/jp/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/
#
# aws iam create-open-id-connect-provider \
#     --url "https://token.actions.githubusercontent.com" \
#     --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" \
#     --client-id-list "sts.amazonaws.com"

# データソース
data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_actions" {
  name = "${var.vars.prefix}-github-actions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.github_actions.arn
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.vars.github_repository_owner_name}/${var.vars.github_repository_name}:*"
          ]
        }
      }
    }]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}
