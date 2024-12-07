data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_func.py"  # Adjust path as needed
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "GetandUpdateStats"
  handler          = "lambda_func.lambda_handler"
  role            = var.lambda_function_role
  runtime         = "python3.12"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
      DYNAMODB_ITEM_NAME = var.dynamodb_item_name
    }
  }
}