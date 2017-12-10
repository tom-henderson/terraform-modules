resource "aws_sns_topic" "cats" {
  name = "cat-pictures"
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = "${length(var.phone_numbers)}"
  topic_arn = "${aws_sns_topic.cats.arn}"
  protocol  = "sms"
  endpoint  = "${element(var.phone_numbers, count.index)}"
}

module "lambda" {
  source      = "../lambda"
  name        = "cat_pictures_lambda"
  description = "Put cat photo urls onto cat-pictures SNS topic."
  source_code = "${path.module}/lambda.zip"
  module_name = "lambda"

  environment_variables = {
    sns_topic = "${aws_sns_topic.cats.arn}"
  }
}

resource "aws_lambda_permission" "allow_execution_from_sns" {
  count          = "${length(var.button_serials)}"
  statement_id   = "AllowExecutionFromIoT"
  action         = "lambda:InvokeFunction"
  function_name  = "${module.lambda.function_name}"
  principal      = "iot.amazonaws.com"
  source_account = "${local.account_id}"
  source_arn     = "arn:aws:iot:${local.region}:${local.account_id}:rule/iotbutton_${element(var.button_serials, count.index)}"
}
