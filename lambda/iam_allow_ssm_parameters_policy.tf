data "aws_iam_policy_document" "read_ssm_parameters" {
  count = "${length(var.ssm_parameters) == 0 ? 0 : 1}"

  statement {
    actions   = ["ssm:GetParameters"]
    resources = ["${formatlist("arn:aws:ssm:::parameter/%s", var.ssm_parameters)}"]
  }
}

resource "aws_iam_policy" "read_ssm_parameters" {
  count  = "${length(var.ssm_parameters) == 0 ? 0 : 1}"
  name   = "${var.name}_read_ssm_parameters_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.read_ssm_parameters.json}"
}

resource "aws_iam_role_policy_attachment" "read_ssm_parameters" {
  count      = "${length(var.ssm_parameters) == 0 ? 0 : 1}"
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.read_ssm_parameters.arn}"
}
