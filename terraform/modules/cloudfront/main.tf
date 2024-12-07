resource "aws_cloudfront_distribution" "root_cfd" {

    origin {
        domain_name = var.bucket_root_website_endpoint
        origin_id = "s3-${var.domain_name}"
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "http-only"
            origin_ssl_protocols = ["TLSv1.2"]
        }       
    }
    
    #identifies the origin to associate with the default_cache_behavior.
    default_cache_behavior {
        target_origin_id       = "s3-${var.domain_name}"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE" ] 
        cached_methods = ["GET", "HEAD"]
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    viewer_certificate {
        acm_certificate_arn = var.acm_certificate_arn
        cloudfront_default_certificate = false
        ssl_support_method = "sni-only"
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    enabled = true
    aliases = [var.domain_name]
    is_ipv6_enabled = true
}

resource "aws_cloudfront_distribution" "www_cfd" {

    origin {
        domain_name = var.bucket_www_website_endpoint
        origin_id = "s3-www.${var.domain_name}"
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "http-only"
            origin_ssl_protocols = ["TLSv1.2"]
        }   
    }
    
    #identifies the origin to associate with the default_cache_behavior.
    default_cache_behavior {
        target_origin_id       = "s3-www.${var.domain_name}"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE" ] 
        cached_methods = ["GET", "HEAD"]
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    viewer_certificate {
        acm_certificate_arn = var.acm_certificate_arn
        cloudfront_default_certificate = false
        ssl_support_method = "sni-only"
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    enabled = true
    aliases = ["www.${var.domain_name}"]
    is_ipv6_enabled = true
}

resource "aws_route53_record" "domin_to_root_cloud_distr" {
    zone_id = var.zone_id
    name = var.domain_name
    type = "A"
    
    alias {
        name = aws_cloudfront_distribution.root_cfd.domain_name
        zone_id = aws_cloudfront_distribution.root_cfd.hosted_zone_id
        evaluate_target_health = false
    }

    depends_on = [aws_cloudfront_distribution.root_cfd]
}

resource "aws_route53_record" "domin_to_www_cloud_distr" {
    zone_id = var.zone_id
    name = "www.${var.domain_name}"
    type = "A"
    
    alias {
        name = aws_cloudfront_distribution.www_cfd.domain_name
        zone_id = aws_cloudfront_distribution.www_cfd.hosted_zone_id
        evaluate_target_health = false
    }

    depends_on = [aws_cloudfront_distribution.www_cfd]
}
