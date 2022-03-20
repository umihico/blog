data "aws_route53_zone" "prod" {
  name = "${var.prod_domain}."
}

data "aws_route53_zone" "dev" {
  name = "${var.dev_domain}."
}


resource "aws_iam_role" "blog" {
  name = "role-assumed-by-blog"

  inline_policy {
    name = "route53-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "route53:GetHostedZone",
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets",
            "route53:ListTagsForResource", # Data Source: aws_route53_zone requires this
          ]
          Effect = "Allow"
          Resource = [
            data.aws_route53_zone.dev.arn,
            data.aws_route53_zone.prod.arn,
          ]
        },
        {
          Action = [
            "route53:ListHostedZones", # Data Source: aws_route53_zone requires this
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "route53:GetChange",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:route53:::change/*"
          ]
        },
      ]
    })
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          "AWS" = [
            "arn:aws:iam::${var.blog_account_id}:role/dev-codebuild-service-role",
            "arn:aws:iam::${var.blog_account_id}:role/prod-codebuild-service-role",
            "arn:aws:iam::${var.blog_account_id}:role/OrganizationAccountAccessRole",
          ]
        },
      },
    ]
  })
}
