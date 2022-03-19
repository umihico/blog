output "all" {
  value = {
    codebuild_project = aws_codebuild_project.this
    codebuild_webhook = {
      id          = aws_codebuild_webhook.this.id
      payload_url = aws_codebuild_webhook.this.payload_url
      # secret = aws_codebuild_webhook.this.secret # Error: Output refers to sensitive values
      url = aws_codebuild_webhook.this.url
    }
  }
}
