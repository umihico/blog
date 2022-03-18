
resource "aws_iam_role" "codebuild" {
  name                = "codebuild"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
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
