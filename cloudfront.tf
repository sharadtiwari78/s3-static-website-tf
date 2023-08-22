locals {
  s3_origin_id = var.s3_origin_id 
}

#crate cloudfront origin access control
resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = var.origin_access_control_name 
  origin_access_control_origin_type = var.origin_access_control_type 
  signing_behavior                  = var.origin_access_control_signing_behavior 
  signing_protocol                  = var.origin_access_control_signing_protocol 
}
#create cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  =  var.cache_behavior 
    cached_methods   = var.cache_method 
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

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type 
      locations        = var.location 
    }
  }
}