data "aws_iam_policy_document" "read_ssm_parameters" {
  count = "${len(var.ssm_parameters)}"

  statement {
    actions   = ["ssm:GetParameters"]
    resources = ["${formatlist("arn:aws:ssm:::parameter/", var.ssm_parameters)}"]
  }
}

resource "aws_iam_policy" "read_ssm_parameters" {
  count  = "${len(var.ssm_parameters)}"
  name   = "${var.name}_read_ssm_parameters_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.read_ssm_parameters.json}"
}

resource "aws_iam_role_policy_attachment" "read_ssm_parameters" {
  count      = "${len(var.ssm_parameters)}"
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.read_ssm_parameters.arn}"
}
