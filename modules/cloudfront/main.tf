resource "aws_cloudfront_distribution" "static-www" {
  # aliases = ["${var.site_domain}"]
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = var.s3_bucket_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static-www.cloudfront_access_identity_path
    }
  }
  enabled         = true
  is_ipv6_enabled = true
  # comment             = var.site_domain
  default_root_object = "index.html"
  custom_error_response {
    error_caching_min_ttl = 360
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn            = aws_acm_certificate.main.arn
    # ssl_support_method             = "sni-only"
    # minimum_protocol_version       = "TLSv1"
  }
}

resource "aws_cloudfront_origin_access_identity" "static-www" {
  # comment = var.site_domain
}