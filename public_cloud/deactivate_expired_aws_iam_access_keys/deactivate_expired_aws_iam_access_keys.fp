pipeline "deactivate_expired_aws_iam_access_keys" {
  title       = "Deactivate expired AWS IAM access keys"
  description = "Deactivates expired AWS IAM access keys and notifies via Slack channel."

  tags = {
    recommended = "true"
  }

  param "aws_conn" {
    type        = connection.aws
    description = "Name for AWS connections to use. If not provided, the default connection will be used."
    default     = var.aws_conn
  }

  param "slack_conn" {
    type        = connection.slak
    description = "Name for Slack connections to use. If not provided, the default connection will be used."
    default     = var.slack_conn
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
  }

  param "expire_after_days" {
    type        = number
    description = "Number of days after which the access key should be deactivated."
    default     = 90
  }

  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
  }

  step "pipeline" "list_iam_access_keys" {
    for_each = { for user in step.pipeline.list_iam_users.output.users : user.UserName => user.UserName }
    pipeline = aws.pipeline.list_iam_access_keys
    args = {
      conn      = param.aws_conn
      user_name = each.value
    }
  }

  step "pipeline" "update_iam_access_key" {
    for_each = flatten([for accessKey in step.pipeline.list_iam_access_keys : accessKey.output.access_keys])
    # Run only if the access key is active and older than specified number of days.
    if       = each.value.Status == "Active" && timecmp(each.value.CreateDate, timeadd(timestamp(), "-${param.expire_after_days * 24}h")) < 0
    pipeline = aws.pipeline.update_iam_access_key
    args = {
      conn          = param.aws_conn
      user_name     = each.value.UserName
      access_key_id = each.value.AccessKeyId
      status        = "Inactive"
    }
  }

  step "pipeline" "post_message" {
    for_each = flatten([for accessKey in step.pipeline.list_iam_access_keys : accessKey.output.access_keys])
    # Run only if the access key is active and older than specified number of days.
    if = each.value.Status == "Active" && timecmp(each.value.CreateDate, timeadd(timestamp(), "-${param.expire_after_days * 24}h")) < 0

    pipeline = slack.pipeline.post_message
    args = {
      conn    = param.slack_conn
      channel = param.slack_channel
      text    = "The access key ${each.value.AccessKeyId} for user ${each.value.UserName} has been deactivated."
    }
  }
}
