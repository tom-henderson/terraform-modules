data "aws_iam_policy_document" "allow_sns_publish" {
  statement {
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.cats.arn}"]
  }
}

resource "aws_iam_policy" "allow_sns_publish" {
  name   = "allow-sns-publish-cat-pictures"
  path   = "/"
  policy = "${data.aws_iam_policy_document.allow_sns_publish.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_allow_sns_publish" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "${aws_iam_policy.allow_sns_publish.arn}"
}
