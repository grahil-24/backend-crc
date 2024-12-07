output "s3_endpoint" {
	value = aws_s3_bucket_website_configuration.bucket_www_website.website_endpoint
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.bucket_root.bucket_regional_domain_name
}

output "bucket_www_regional_domain_name" {
	value = aws_s3_bucket.bucket_www.bucket_regional_domain_name
}

output "bucket_root_website_endpoint" {
	value = aws_s3_bucket_website_configuration.bucket_root_website.website_endpoint
}

output "bucket_www_website_endpoint" {
	value = aws_s3_bucket_website_configuration.bucket_www_website.website_endpoint
}