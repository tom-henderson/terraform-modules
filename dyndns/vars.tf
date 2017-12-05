variable "zone_id" {
  description = "Zone to update dynamic records in"
}

data "aws_route53_zone" "zone" {
  zone_id = "${var.zone_id}"
}

variable "dynamic_records" {
  description = "List of dynamic records that can be updated"
  default     = []
}

variable "username_parameter" {
  description = "Parameter store item containing the username"
  default     = "dyndns_username"
}

variable "password_parameter" {
  description = "Parameter store item containing the password"
  default     = "dyndns_password"
}
