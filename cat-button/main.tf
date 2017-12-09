resource "aws_sns_topic" "cats" {
  name = "cat-pictures"
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = "${length(var.numbers)}"
  topic_arn = "${aws_sns_topic.cats.arn}"
  protocol  = "sms"
  endpoint  = "${element(var.numbers, count.index)}"
}
