

resource "aws_cloudfront_distribution" "webapp_origin" {
  aliases = ["${var.sparedevice_webapp_domain}"]
  origin {
    domain_name = "${aws_s3_bucket.webapp.bucket_regional_domain_name}"
    origin_id   = "${var.s3_webapp_bucket_name}"

    #s3_origin_config {
    #  origin_access_identity = "${aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path}"
    #}
  }

  web_acl_id = "${aws_wafv2_web_acl.cf-web-acl.arn}"

  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = false

  custom_error_response {
       error_code         = 404
       response_code      = 200
       response_page_path = "/index.html"
  }

 default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.s3_webapp_bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
    acm_certificate_arn = "${var.sparedevice_cert_arn}"
  }

}
