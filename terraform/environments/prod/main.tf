locals {
  prefix = { prefix = "prod" }
}

module "base" {
  source = "../base"
  vars   = local.prefix
}
