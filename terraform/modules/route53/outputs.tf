output "all" {
  value = {
    route53_zone = data.aws_route53_zone.this
  }
}
