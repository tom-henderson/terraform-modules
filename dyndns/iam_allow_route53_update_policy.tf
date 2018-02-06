data "aws_iam_policy_document" "allow_route53_update" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${var.zone_id}"]
  }
}

resource "aws_iam_policy" "allow_route53_update" {
  name   = "${local.module_name}_allow_route53_update"
  path   = "/"
  policy = "${data.aws_iam_policy_document.allow_route53_update.json}"
}

resource "aws_iam_role_policy_attachment" "allow_route53_update" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "${aws_iam_policy.allow_route53_update.arn}"
}
