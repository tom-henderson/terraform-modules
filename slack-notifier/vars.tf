variable "slack_team_name" {
  description = "Name of the slack team"
}

variable "slack_api_token_parameter" {
  description = "Parameter store item containing the slack API token"
  default     = "slack_api_token"
}

variable "sns_queue_name_parameter" {
  description = "Parameter store item containing the slack API token"
  default     = "slack_api_token"
}
