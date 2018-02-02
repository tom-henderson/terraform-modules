data "aws_iam_policy_document" "allow_update_route53_records" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${var.zone_id}"]
  }
}

resource "aws_iam_policy" "allow_update_route53_records" {
  name   = "allow-update-route53-records"
  path   = "/"
  policy = "${data.aws_iam_policy_document.allow_update_route53_records.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_allow_update_route53_records" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "${aws_iam_policy.allow_update_route53_records.arn}"
}
