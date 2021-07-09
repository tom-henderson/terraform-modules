data "aws_iam_policy_document" "allow_read_parameter_store" {
  statement {
    actions = ["ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:${module.lambda.region}:${local.account_id}:parameter/${var.slack_api_token_parameter}",
      "arn:aws:ssm:${module.lambda.region}:${local.account_id}:parameter/${var.sns_queue_name_parameter}",
    ]
  }
}

resource "aws_iam_policy" "allow_read_parameter_store" {
  name   = "allow-read-parameter-store"
  path   = "/"
  policy = "${data.aws_iam_policy_document.allow_read_parameter_store.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_allow_read_parameter_store" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "${aws_iam_policy.allow_read_parameter_store.arn}"
}
