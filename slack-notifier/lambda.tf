module "lambda" {
  source      = "../lambda"
  name        = "${local.module_name}_lambda"
  description = "Slack notifier for ${var.slack_team_name}"
  source_code = "${path.module}/slack_notifier.zip"
  module_name = "slack_notifier"

  environment_variables = {
    slack_api_token_parameter = "${var.slack_api_token_parameter}"
    sns_topic_name            = "${aws_sns_topic.topic.name}"
  }
}

resource "aws_sns_topic" "topic" {
  name = "${module.lambda.function_name}"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "lambda"
  endpoint  = "${module.lambda.arn}"
}

resource "aws_lambda_permission" "allow_execution_from_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.topic.arn}"
}
