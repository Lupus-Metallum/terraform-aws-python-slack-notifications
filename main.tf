data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/src/slack.py"
  output_path = "${path.module}/src/slack.zip"
}

data "aws_secretsmanager_secret" "this" {
  arn = var.webhook_secret_arn
}

resource "aws_lambda_function" "this" {
  description                    = "An Amazon SNS trigger that sends CloudWatch alarm notifications to Slack."
  filename                       = data.archive_file.this.output_path
  function_name                  = var.name
  handler                        = "slack.lambda_handler"
  memory_size                    = 128
  publish                        = false
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.this.arn
  runtime                        = "python3.7"
  source_code_hash               = data.archive_file.this.output_base64sha256
  timeout                        = 30

  environment {
    variables = {
      slackChannel  = var.slack_channel,
      iconEmoji     = var.slack_emoji_icon,
      hookUrl       = data.aws_secretsmanager_secret.this.name,
      messageHeader = var.slack_message_header,
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.security_group_ids) > 0 && length(var.subnet_ids) > 0 ? [0] : []
    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  dynamic "tracing_config" {
    for_each = var.lambda_tracing ? [0] : []
    content {
      mode = "Active"
    }
  }

  tags = var.tags
}

resource "aws_kms_key" "this" {
  count       = var.sns_encryption ? 1 : 0
  description = var.kms_key_description
}

resource "aws_kms_alias" "this" {
  count         = var.sns_encryption ? 1 : 0
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this[0].key_id
}

resource "aws_sns_topic" "this" {
  name              = var.name
  kms_master_key_id = var.sns_encryption ? aws_kms_key.this[0].key_id : null
}

resource "aws_sns_topic_subscription" "this" {
  endpoint  = aws_lambda_function.this.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.this.arn
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  statement_id  = "AllowSubscriptionToSNS"
  source_arn    = aws_sns_topic.this.arn
}

data "aws_iam_policy_document" "this_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name}-role"
  description        = "Ability to send Cloudwatch info in an SNS message to Slack"
  assume_role_policy = data.aws_iam_policy_document.this_assume.json
  tags               = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecrets"
    ]
    resources = [
      data.aws_secretsmanager_secret.this.arn
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.name}-policy"
  description = "Ability to send Cloudwatch info in an SNS message to Slack"
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "this_basic" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "this_vpc" {
  count      = length(var.security_group_ids) > 0 && length(var.subnet_ids) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "this_insights" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "this_xray" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "this_sns" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
}
