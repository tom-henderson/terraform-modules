module "lambda" {
  source      = "../lambda"
  name        = "${local.module_name}_lambda"
  description = "Route53 Dynamic DNS updater for ${data.aws_route53_zone.zone.name} (${data.aws_route53_zone.zone.zone_id})"
  source_code = "${path.module}/dyndns.zip"
  module_name = "dyndns"

  ssm_parameters = [
    "${var.username_parameter}",
    "${var.password_parameter}",
  ]

  environment_variables = {
    username_parameter = "${var.username_parameter}"
    password_parameter = "${var.password_parameter}"
    dynamic_records    = "${join(",", var.dynamic_records)}"
    zone_name          = "${data.aws_route53_zone.zone.name}"
    zone_id            = "${data.aws_route53_zone.zone.zone_id}"
  }
}
