data "aws_caller_identity" "self" {}

resource "aws_iam_role" "codebuild" {
  name                = "${var.vars.prefix}-codebuild-service-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  inline_policy {
    name = "assume-role-to-parent"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [{
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:PassRole"
        ],
        "Resource" : "arn:aws:iam::${var.vars.master_account_id}:role/role-assumed-by-blog"
        }, {
        "Effect" : "Allow",
        "Action" : ["iam:Get*", "iam:List*"],
        "Resource" : "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/${var.vars.prefix}-codebuild-service-role" # to refresh terraform state
      }]
    })
  }
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
