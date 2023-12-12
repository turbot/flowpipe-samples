pipeline "deactivate_expired_aws_iam_access_keys" {
  title = "Deactivate expired AWS IAM access keys"
  description = "Deactivates expired AWS IAM access keys and notifies via Slack channel."

  param "aws_region" {
    description = "The AWS region to use."
    type        = string
    default     = var.aws_region
  }

  param "aws_cred" {
    description = "Name for AWS credential to use. If not provided, the default credential will be used."
    type        = string
    default     = var.aws_cred
  }

  param "slack_cred" {
    description = "Name for Slack credential to use. If not provided, the default credential will be used."
    type        = string
    default     = var.slack_cred
  }

  param "slack_channel" {
    type        = string
    description = "Channel containing the message to be updated."
    default     = var.slack_channel
  }

  param "expire_after_days" {
    type        = number
    description = "Number of days after which the access key should be deactivated."
    default     = 90
  }

  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
    args = {
      cred = param.aws_cred
    }
  }

  step "pipeline" "list_iam_access_keys" {
    for_each = step.pipeline.list_iam_users.output.users
    pipeline = aws.pipeline.list_iam_access_keys
    args = {
      cred      = param.aws_cred
      user_name = each.value.UserName
    }
  }

  step "pipeline" "update_iam_access_key_status" {
    for_each = concat([for access_keys in step.pipeline.list_iam_access_keys.output.access_keys: access_keys])
    # Run only if the access key is active and older than specified number of days.
    if = each.value.Status == "Active" && timecmp(each.value.CreateDate, timeadd(timestamp(), "-${param.expire_after_days*24}h")) < 0
    pipeline = aws.pipeline.update_iam_access_key_status
    args = {
      cred          = param.aws_cred
      user_name     = each.value.UserName
      access_key_id = each.value.AccessKeyId
      status        = "Inactive"
    }
  }

  step "pipeline" "post_message" {
    for_each = concat([for access_keys in step.pipeline.list_iam_access_keys.output.access_keys: access_keys])
    # Run only if the access key is active and older than specified number of days.
    if = each.value.Status == "Active" && timecmp(each.value.CreateDate, timeadd(timestamp(), "-${param.expire_after_days*24}h")) < 0

    pipeline = slack.pipeline.post_message
    args = {
      cred    = param.slack_cred
      channel = param.slack_channel
      message = "The access key ${each.value.AccessKeyId} for user ${each.value.UserName} has been deactivated."
    }
  }

  # Reenable for debugging
  # output "iam_users" {
  #   description = "List of IAM users."
  #   value       = step.pipeline.list_iam_users.output.stdout
  # }

  # Reenable for debugging
  # output "update_iam_access_key_status" {
  #   description = "List of access keys."
  #   value       = step.pipeline.update_iam_access_key_status
  # }

  # Reenable for debugging
  # output "access_keys" {
  #   description = "List of access keys."
  #   value       = step.pipeline.list_iam_access_keys
  # }

  # Reenable for debugging
  # output "iam_users" {
  #   description = "List of IAM users."
  #   value       = step.pipeline.list_iam_users.output.stdout
  # }

}

# Runs daily at midnight UTC
trigger "schedule" "run_on_daily_basis" {
  schedule = "0 0 * * *"
  pipeline = pipeline.deactivate_expired_aws_iam_access_keys
}
