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

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this_xray](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | The name slack channel to send alerts to | `string` | n/a | yes |
| <a name="input_webhook_secret_arn"></a> [webhook\_secret\_arn](#input\_webhook\_secret\_arn) | The arn of the AWS Secret containing the slack webhook url | `string` | n/a | yes |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | description of what the key is used for | `string` | `"kms key created by slack alerter to encrypt resources"` | no |
| <a name="input_lambda_tracing"></a> [lambda\_tracing](#input\_lambda\_tracing) | Should we enable lambda tracing? | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for resources created by this module | `string` | `"Slack-Alerter"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | ids of the security groups to be used by the lambda function | `list(string)` | `[]` | no |
| <a name="input_slack_emoji_icon"></a> [slack\_emoji\_icon](#input\_slack\_emoji\_icon) | The emoji to use in slack messages | `string` | `":ghost"` | no |
| <a name="input_slack_message_header"></a> [slack\_message\_header](#input\_slack\_message\_header) | The message header to send | `string` | `"slack_message_header"` | no |
| <a name="input_sns_encryption"></a> [sns\_encryption](#input\_sns\_encryption) | Should we encrypt the SNS topic with a new KMS key? | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | subnet ids for the lambda function | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources created by this module | `map` | `{}` | no |
<!-- END_TF_DOCS -->