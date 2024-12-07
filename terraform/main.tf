terraform {
  backend "s3" {
    bucket         = "tfstate-mgnt"
    key            = "state/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}


module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain
}

module "s3" {
  source      = "./modules/s3"
  domain = var.domain
}

module "cer" {
  source = "./modules/cer"
  domain_name = var.domain
  certificate_route53_zone = module.route53.zone_id
}

module "cloudfront" {
  source = "./modules/cloudfront"
  domain_name = var.domain
  region = var.region
  acm_certificate_arn = module.cer.acm_certificate_arn
  bucket_root_website_endpoint = module.s3.bucket_root_website_endpoint
  bucket_www_website_endpoint = module.s3.bucket_www_website_endpoint
  zone_id = module.route53.zone_id

  depends_on = [
    module.cer.aws_acm_certificate_validation
  ]
}

module "IAM_Role" {
  source = "./modules/IAM_Role"
}

module "dynamoDB" {
  source = "./modules/dynamoDB"
  dynamodb_table_name = var.dynamodb_table_name
  dynamodb_item_name = var.dynamodb_item_name
}

module "lambda" {
  source = "./modules/lambda"
  lambda_function_role = module.IAM_Role.lambda_function_role
  dynamodb_table_name = var.dynamodb_table_name
  dynamodb_item_name = var.dynamodb_item_name
}

module "api-gateway" {
  source = "./modules/api-gateway"
  resource_name_api = var.resource_name_api
  lambda_function_invoke_arn = module.lambda.lambda_function_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
}

