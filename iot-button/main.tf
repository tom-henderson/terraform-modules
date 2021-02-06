resource "aws_iot_thing" "button" {
  name = "${local.name}"
}

# https://www.terraform.io/docs/providers/aws/r/iot_policy.html
# https://github.com/terraform-providers/terraform-provider-aws/pull/986
resource "aws_iot_policy" "button" {
  name = "${local.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "iot:Publish",
      "Effect": "Allow",
      "Resource": "${aws_iot_thing.button.arn}"
    }
  ]
}
EOF
}

# https://www.terraform.io/docs/providers/aws/r/iot_topic_rule.html
# https://github.com/terraform-providers/terraform-provider-aws/pull/1858
resource "aws_iot_topic_rule" "button" {}

# https://www.terraform.io/docs/providers/aws/r/aws_iot_certificate.html
# https://github.com/terraform-providers/terraform-provider-aws/pull/1225
resource "aws_iot_certificate" "button" {}
