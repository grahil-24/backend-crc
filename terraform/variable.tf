variable "region" {
	description = "name of the region"
	type = string
}

variable "domain" {
	description = "name of our domain. will be useful in configuring s3 bucket and route53"
	type = string
}

variable "static_site_path" {
  description = "path to the static site on the local machine which will be uploaded to the s3 bucket"
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_item_name" {
  type = string
}

variable "resource_name_api" {
  type = string
}