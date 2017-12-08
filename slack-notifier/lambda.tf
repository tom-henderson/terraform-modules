module "lambda" {
  source      = "../lambda"
  name        = "${local.module_name}_lambda"
  description = "Slack notifier for ${var.slack_team_name}"
  source_code = "${path.module}/slack_notifier.zip"
  module_name = "slack_notifier"

  environment_variables = {
    slack_api_token_parameter = "${var.slack_api_token_parameter}"
    sns_queue_name_parameter  = "${var.sns_queue_name_parameter}"
  }
}
