resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = "${var.log_retention_in_days}"
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "allow_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.logs.arn}"]
  }
}

resource "aws_iam_policy" "lambda" {
  name   = "${var.name}_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.allow_cloudwatch_logs.json}"
}

resource "aws_iam_role" "lambda" {
  name               = "${var.name}_iam_role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.lambda.arn}"
}

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

output "arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.lambda.invoke_arn}"
}

output "name" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "iam_role_name" {
  value = "${aws_iam_role.lambda.name}"
}