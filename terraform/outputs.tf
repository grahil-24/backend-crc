output "website_endpoint" {
  value = module.s3.s3_endpoint
}

output "deployment_invoke_url" {
  value = module.api-gateway.deployment_invoke_url
}