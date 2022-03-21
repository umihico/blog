terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

locals {
  origin_id = "s3origin"
}

resource "aws_cloudfront_origin_access_identity" "this" {
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.vars.s3.private_buckets["sls-assets"].bucket_regional_domain_name
    origin_id   = local.origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  wait_for_deployment = true
  is_ipv6_enabled     = true
  comment             = var.vars.prefix
  price_class         = "PriceClass_All"

  aliases = [var.vars.domain]
  viewer_certificate {
    acm_certificate_arn            = var.vars.acm_usa.certificate.arn
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
  }

  default_root_object = "index.html"

  custom_error_response {
    error_code         = "404"
    response_code      = "404"
    response_page_path = "/404/index.html"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    compress               = true
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

module "s3" {
  source = "../../modules/s3/cloudfront"
  vars = merge(var.vars, {
    cloudfront_origin_access_identity = aws_cloudfront_origin_access_identity.this
  })
}

module "route53" {
  source = "../../modules/route53/cloudfront"
  vars = merge(var.vars, {
    cloudfront_distribution = aws_cloudfront_distribution.this
  })
  providers = {
    aws = aws.parent,
  }
}
