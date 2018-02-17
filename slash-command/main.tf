module "lambda" {
  source                = "../lambda"
  name                  = "${var.name}_lambda"
  description           = "${var.description}"
  source_code           = "${var.source_code}"
  module_name           = "${var.module_name}"
  handler               = "${var.handler}"
  memory_size           = "${var.memory_size}"
  timeout               = "${var.timeout}"
  ssm_parameters        = ["${var.ssm_parameters}"]
  environment_variables = "${var.environment_variables}"
  log_retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_lambda_permission" "allow_execution" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

output "lambda_arn" {
  value = "${module.lambda.arn}"
}

output "lambda_invoke_arn" {
  value = "${module.lambda.invoke_arn}"
}

output "lambda_name" {
  value = "${module.lambda.arn}"
}

output "lambda_function_name" {
  value = "${module.lambda.function_name}"
}

output "iam_role_name" {
  value = "${module.lambda.iam_role_name}"
}
