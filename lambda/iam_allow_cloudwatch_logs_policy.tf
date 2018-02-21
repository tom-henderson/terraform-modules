data "aws_iam_policy_document" "allow_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.logs.arn}"]
  }
}

resource "aws_iam_role_policy" "allow_cloudwatch_logs" {
  name   = "${var.name}_allow_cloudwatch_logs_policy"
  policy = "${data.aws_iam_policy_document.allow_cloudwatch_logs.json}"
  role   = "${aws_iam_role.lambda.name}"
}
