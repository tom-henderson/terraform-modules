variable "name" {}
variable "description" {}
variable "source_code" {}

variable "runtime" {
  default = "python2.7"
}

variable "module_name" {
  default = "lambda"
}

variable "handler" {
  default = "lambda_handler"
}

variable "memory_size" {
  default = "128"
}

variable "timeout" {
  default = "20"
}

variable "log_retention_in_days" {
  default = 1
}

variable "environment_variables" {
  default = {}
}

variable "schedule" {
  default = "NONE"
}
