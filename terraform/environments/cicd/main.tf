module "codebuild" {
  source = "../../modules/codebuild"
  vars = merge(jsondecode(var.vars), {
    name = "cicd"
  })
}
