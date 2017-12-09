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
