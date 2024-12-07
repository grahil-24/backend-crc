output "zone_id" {
  value       = aws_route53_zone.site_host_zone.zone_id
  description = "The Hosted Zone ID of the newly created Route53 zone"
}