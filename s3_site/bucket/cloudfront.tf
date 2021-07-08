locals {
  s3_origin_id = "${aws_s3_bucket.site.bucket_regional_domain_name}"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.domain}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {  // CDN
  origin {
    domain_name = "${local.s3_origin_id}"
    origin_id   = "${local.s3_origin_id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Managed by Terraform"
  default_root_object = "index.html" // Objeto default

  logging_config { // configurando log
    include_cookies = true  // Coleta de cookies
    bucket          = "${aws_s3_bucket.log.bucket_domain_name}" // Bucket criado para log em "s3.tf"
    prefix          = "cdn"
  }

  aliases = ["${var.domain}"] // Config alias

  default_cache_behavior { // Config metodos behavior
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600                # 1h
    max_ttl                = 86400               # 1d
  }

  price_class = "PriceClass_200" // Região de deploy das edge locations, confira outras opções em https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "none"
    ssl_support_method  = "none"
  }
}