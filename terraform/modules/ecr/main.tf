resource "aws_ecr_repository" "codebuild" {
  name = "${var.vars.prefix}-codebuild"
}

resource "aws_ecr_lifecycle_policy" "codebuild" {
  repository = aws_ecr_repository.codebuild.name
  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep last 3 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 3
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}

data "aws_region" "current" {}
data "aws_caller_identity" "self" {}

data "local_file" "codebuild" {
  filename = "${path.module}/Dockerfile"
}

resource "null_resource" "executor" {
  # probably won't work in codebuild because of DinD. Trigger this only local.
  triggers = {
    md5_Dockerfile = md5(data.local_file.codebuild.content)
  }

  provisioner "local-exec" {
    command = join(" && ", compact([
      "aws ecr get-login-password | docker login --username AWS --password-stdin ${data.aws_caller_identity.self.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com",
      "docker image build -t ${aws_ecr_repository.codebuild.repository_url}:latest - < ${path.module}/Dockerfile",
      "docker push ${aws_ecr_repository.codebuild.repository_url}:latest",
    ]))
  }
}
