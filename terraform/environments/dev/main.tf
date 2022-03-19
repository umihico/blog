locals {
  vars = merge(jsondecode(var.vars), {
    prefix = "dev"
    branch = "development"
  })
}
module "base" {
  source = "../base"
  vars   = local.vars
}
