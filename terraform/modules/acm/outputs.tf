output "all" {
  value = {
    certificate            = jsondecode(nonsensitive(jsonencode(aws_acm_certificate.this)))
    route53                = module.route53
    # certificate_validation = aws_acm_certificate_validation.this
  }
}
