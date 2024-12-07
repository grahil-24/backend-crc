# dont change the provided for cert. only works in us-east-1 region
provider "aws" {
  region = "us-east-1"
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = "www.${var.domain_name}"
  subject_alternative_names = [var.domain_name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Instead of using for_each, we'll create separate records for root and www
resource "aws_route53_record" "cert_validation_root" {
  name    = tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_type
  zone_id = var.certificate_route53_zone
  records = [tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_www" {
  name    = tolist(aws_acm_certificate.certificate.domain_validation_options)[1].resource_record_name
  type    = tolist(aws_acm_certificate.certificate.domain_validation_options)[1].resource_record_type
  zone_id = var.certificate_route53_zone
  records = [tolist(aws_acm_certificate.certificate.domain_validation_options)[1].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation_root.fqdn,
    aws_route53_record.cert_validation_www.fqdn
  ]
}