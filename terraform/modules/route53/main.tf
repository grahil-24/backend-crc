resource "aws_route53_zone" "site_host_zone" {
  name = var.domain_name
}

