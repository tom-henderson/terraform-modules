resource "aws_lambda_function" "lambda" {
  function_name = "${var.name}"
  description   = "${var.description}"

  runtime          = "${var.runtime}"
  filename         = "${var.source_code}"
  source_code_hash = "${base64sha256(file("${var.source_code}"))}"
  handler          = "${var.module_name}.${var.handler}"

  role        = "${aws_iam_role.lambda.arn}"
  memory_size = "${var.memory_size}"
  timeout     = "${var.timeout}"

  environment {
    variables = "${var.environment_variables}"
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = "${var.log_retention_in_days}"
}

output "arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.lambda.invoke_arn}"
}

output "name" {
  value = "${aws_lambda_function.lambda.arn}"
}
