locals {
  prefix = { prefix = "dev" }
}

module "base" {
  source = "../base"
  vars   = local.prefix
}
