<img src="https://raw.githubusercontent.com/Lupus-Metallum/brand/master/images/logo.jpg" width="400"/>

# terraform-aws-python-slack-notifications

A Terraform module for deploying and managing a Python (3.7) lambda function to send SNS messages to a Slack channel via Webhook.

## Getting Started

Most basic usage:

```hcl
module "terraform-aws-python-slack-notifications" {
  source  = "Lupus-Metallum/python-slack-notifications/aws"
  version = "0.9.0"

  name               = "slack-alerter"
  webhook_secret_arn = "arn:aws:secretsmanager:region:000000000000:secret:secret-id"
  slack_channel      = "aws-alerts"
  slack_emoji_icon   = ":ghost"
}
```
