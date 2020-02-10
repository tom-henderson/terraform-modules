resource "aws_api_gateway_rest_api" "api" {
  name = "${local.module_name}_api"
}

# GET /nic/update?hostname=mytest.testdomain.com&myip=1.2.3.4 HTTP/1.0
# Host: dynupdate.no-ip.com
# Authorization: Basic base64-encoded-auth-string
# User-Agent: Bobs Update Client WindowsXP/1.2 bob@somedomain.com

resource "aws_api_gateway_resource" "nic" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "nic"
}

resource "aws_api_gateway_resource" "update" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_resource.nic.id}"
  path_part   = "update"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id          = "${aws_api_gateway_rest_api.api.id}"
  resource_id          = "${aws_api_gateway_resource.update.id}"
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = "${aws_api_gateway_request_validator.validate_request_parameters.id}"

  request_parameters {
    method.request.querystring.hostname = true
    method.request.querystring.myip     = true
  }
}

resource "aws_api_gateway_request_validator" "validate_request_parameters" {
  rest_api_id                 = "${aws_api_gateway_rest_api.api.id}"
  name                        = "validate-request-parameters"
  validate_request_parameters = true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.update.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "production"
  depends_on  = ["aws_api_gateway_integration.integration"]
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.update.path}"
}

output "api_invoke_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

output "update_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}${aws_api_gateway_resource.update.path}"
}
