output "lambda_function_role" {
    value = aws_iam_role.lambda_dynamodb_role.arn
    description = "ARN of the IAM role required for lambda function"
}