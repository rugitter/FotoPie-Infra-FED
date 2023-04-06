# resource "aws_s3_bucket" "b" {
#   bucket = "mybucket"

#   tags = {
#     Name = "My bucket"
#   }
# }

# resource "aws_s3_bucket_acl" "b_acl" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }

locals {
  s3_origin_id = var.s3_origin_id
}

resource "aws_cloudfront_distribution" "s3_cdn" {
  origin {
    domain_name              = var.bucket_regional_domain_name
    # origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Example CloudFront distribution"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "log.fotopie.ccdemo.link"
    prefix          = "cdn"
  }

  aliases = ["fotopie.ccdemo.link"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "AU"]
    }
  }

  tags = {
    Environment = "uat"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}