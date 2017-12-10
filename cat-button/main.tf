resource "aws_sns_topic" "cats" {
  name = "cat-pictures"
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = "${length(var.numbers)}"
  topic_arn = "${aws_sns_topic.cats.arn}"
  protocol  = "sms"
  endpoint  = "${element(var.numbers, count.index)}"
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
  statement_id  = "AllowExecutionFromIoT"
  principal     = "iot.amazonaws.com"
  action        = "lambda:InvokeFunction"
  resource      = "${module.lambda.arn}"
  function_name = "${module.lambda.function_name}"

  condition = {
    test     = "StringEquals"
    variable = "AWS:SourceAccount"
    values   = ["${local.account_id}"]
  }

  condition = {
    test     = "ArnLike"
    variable = "AWS:SourceArn"
    values   = ["arn:aws:iot:${local.region}:${local.account_id}:rule/iotbutton_${var.button_serial}"]
  }
}
