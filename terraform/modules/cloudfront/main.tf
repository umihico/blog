terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.parent]
    }
  }
}

locals {
  origin_id        = "s3origin"
  basic_auth_logic = <<CODE
    // https://dev.classmethod.jp/articles/apply-basic-authentication-password-with-cloudfront-functions/
    // ユーザー名は ${var.vars.github_repository_name}
    // パスワードは ${random_password.basic_auth.result}
    var authString = "Basic ${base64encode("${var.vars.github_repository_name}:${random_password.basic_auth.result}")}";
    if (
      typeof headers.authorization === "undefined" ||
      headers.authorization.value !== authString
    ) {
      return {
        statusCode: 401,
        statusDescription: "Unauthorized",
        headers: { "www-authenticate": { value: "Basic" } }
      };
    }
CODE
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
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.viewer_request.arn
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

resource "random_password" "basic_auth" {
  # 値はここで確認できる
  # https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=ap-northeast-1#/functions/dev-viewer-request
  length = 20
}

resource "aws_cloudfront_function" "viewer_request" {
  # You can associate a single function per event type. See Cloudfront Functions for more information.
  # とのことで、末尾スラッシュ加工と、ベーシック認証が一つのコードに同居している
  name    = "${var.vars.prefix}-viewer-request"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = <<CODE
function handler(event) {
    var request = event.request;
    var headers = request.headers;
    var uri = request.uri;

    // https://dev.classmethod.jp/articles/cloudfront-url-cff/
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    ${var.vars.basic_auth ? local.basic_auth_logic : ""}

    return request;
}
CODE
}
