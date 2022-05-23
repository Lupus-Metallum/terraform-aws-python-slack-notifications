variable "name" {
  description = "The name to use for resources created by this module"
  type        = string
  default     = "Slack-Alerter"
}

variable "webhook_secret_arn" {
  description = "The arn of the AWS Secret containing the slack webhook url"
  type        = string
}

variable "slack_channel" {
  description = "The name slack channel to send alerts to"
  type        = string
}

variable "slack_emoji_icon" {
  description = "The emoji to use in slack messages"
  type        = string
  default     = ":ghost"
}

variable "slack_message_header" {
  description = "The message header to send"
  type        = string
  default     = "slack_message_header"
}

variable "sns_encryption" {
  description = "Should we encrypt the SNS topic with a new KMS key?"
  type        = bool
  default     = false
}

variable "lambda_tracing" {
  description = "Should we enable lambda tracing?"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources created by this module"
  type        = map
  default     = {}
}

variable "kms_key_description" {
  description = "description of what the key is used for"
  default     = "kms key created by slack alerter to encrypt resources"
}

variable "security_group_ids" {
  description = "ids of the security groups to be used by the lambda function"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "subnet ids for the lambda function"
  type        = list(string)
  default     = []
}