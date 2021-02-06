variable "serial_number" {}

locals {
  name = "iotbutton_${var.serial_number}"
}
