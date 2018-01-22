resource "aws_cloudwatch_event_rule" "event_rule" {
  count               = "${var.schedule == "NONE" ? 0 : 1}"
  name                = "${var.name}-lambda-event-rule"
  description         = "${var.name} event rule"
  schedule_expression = "${var.schedule}"
}

resource "aws_cloudwatch_event_target" "event_target" {
  count     = "${var.schedule == "NONE" ? 0 : 1}"
  rule      = "${aws_cloudwatch_event_rule.event_rule.name}"
  target_id = "${var.name}"
  arn       = "${aws_lambda_function.lambda.arn}"
}

resource "aws_lambda_permission" "allow_execution_from_cloudwatch" {
  count         = "${var.schedule == "NONE" ? 0 : 1}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.aws_lambda_function.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.event_rule.arn}"
}
