output "all" {
  value = {
    base = module.base.all
    ns   = module.ns.all
  }
}
