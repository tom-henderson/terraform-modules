variable "region" {
  default = "current"
}

variable "account_id" {
  default = "current"
}

data "aws_region" "current" {
  current = true
}

data "aws_caller_identity" "current" {}

locals {
  region      = "${var.region == "current" ? data.aws_region.current.name : var.region}"
  account_id  = "${var.account_id == "current" ? data.aws_caller_identity.current.account_id : var.account_id}"
  module_name = "dyndns_${replace(replace(data.aws_route53_zone.zone.name, ".", "_"), "/_$/", "")}"
}

output "region" {
  value = "${local.region}"
}

output "account_id" {
  value = "${local.account_id}"
}
