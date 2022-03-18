module "codebuild" {
  source = "../../modules/codebuild"
  vars = {
    name = "cicd"
  }
}
