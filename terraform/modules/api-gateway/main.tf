resource "aws_api_gateway_rest_api" "apigateway" {
  name        = "rest-api"
  description = "rest api, created by alparius/api-gateway-with-cors"
}


### permission to invoke lambdas
resource "aws_lambda_permission" "apigw_access_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/*/*"
}


### api route
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = var.resource_name_api
}


### connecting the api gateway with the internet
resource "aws_api_gateway_method" "main_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "POST"
  authorization = "NONE"

}


### default 'OK' response
resource "aws_api_gateway_method_response" "main_method_200" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.main_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}


### connecting the api gateway with the lambda
resource "aws_api_gateway_integration" "method_integration" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_method.main_method.resource_id
  http_method = aws_api_gateway_method.main_method.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.lambda_function_invoke_arn

  depends_on = [aws_api_gateway_method.main_method]
}


### integration response
resource "aws_api_gateway_integration_response" "method_integration_200" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.main_method.http_method
  status_code = aws_api_gateway_method_response.main_method_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method_response.main_method_200,
    aws_api_gateway_integration.method_integration
  ]
}


# ------------------------------------------------------------------
# enabling CORS by adding an OPTIONS method
# ------------------------------------------------------------------

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}


resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.options_method]
}


resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }

  depends_on = [aws_api_gateway_method.options_method]
}


resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method_response.options_response,
    aws_api_gateway_integration.options_integration
  ]
}


# ------------------------------------------------------------------
# at last, deployment
# ------------------------------------------------------------------

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  stage_name = "prod"

  depends_on = [
    aws_api_gateway_integration.method_integration,
    aws_api_gateway_integration.options_integration
  ]
}