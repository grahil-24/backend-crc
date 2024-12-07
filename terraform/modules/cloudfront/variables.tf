variable "domain_name" {
  description = "The domain name for the Route53 hosted zone"
  type        = string
}

variable "region" {
    type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "bucket_www_website_endpoint" {
    description = "The website endpoint of the S3 bucket for CloudFront origin."
    type        = string
}

variable "bucket_root_website_endpoint" {
    description = "The website endpoint of the S3 bucket for CloudFront origin."
    type        = string
}

variable "zone_id" {
  description = "hosted zone for our domain in route53"
  type = string
}