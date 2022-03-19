locals {
  vars = merge(jsondecode(var.vars), {
    prefix = "prod"
    branch = "main"
  })
}
module "base" {
  source = "../base"
  vars   = local.vars
}
