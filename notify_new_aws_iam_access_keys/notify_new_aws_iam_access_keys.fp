trigger "schedule" "notify_new_aws_iam_access_keys" {
  description = "Check daily for new access keys"
  schedule    = "0 12 * * *"
  pipeline    = pipeline.notify_new_aws_iam_access_keys
}

pipeline "notify_new_aws_iam_access_keys" {
  title       = "AWS IAM Access Keys"
  description = "AWS IAM access keys that were created in the last 24 hours"

  param "slack_channel" {
    type        = string
    description = "Slack channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  # Get the list of AWS IAM Users
  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
    args = {
      region            = var.aws_region
      access_key_id     = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
    }

    # When there are zero IAM users, exit the pipeline.
    throw {
      if      = result.output.stdout.Users == null
      message = "There are no IAM Users in the account. Exiting the pipeline."
    }
  }

  # Get the list of AWS Access Keys for each user. Each user can have multiple (max 2) access keys.
  step "pipeline" "list_iam_access_keys_for_user" {
    for_each = { for user in step.pipeline.list_iam_users.output.stdout.Users : user.UserName => user.UserName }
    pipeline = aws.pipeline.list_iam_access_keys
    args = {
      region            = var.aws_region
      access_key_id     = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
      user_name         = each.value
    }
  }

  # Transform the list of AWS Access Keys for each user to only include the keys that were created in the last 24 hours.
  step "transform" "new_access_keys" {
    for_each = { for user, keys in step.pipeline.list_iam_access_keys_for_user : user => keys.output.stdout.AccessKeyMetadata
      if try(length(keys.output.stdout.AccessKeyMetadata), 0) > 0
    }
    value = [for key in each.value : key if timecmp(key.CreateDate, timeadd(timestamp(), "-24h")) >= 0]
  }

  # Notify Slack of the new AWS Access Keys
  step "pipeline" "notify_slack" {
    for_each = { for user, keys in step.transform.new_access_keys : user => keys.value }
    pipeline = slack.pipeline.post_message
    args = {
      message = <<EOM
      ${join("\n", [for key in each.value : "User: ${each.key}, AccessKeyId: ${key.AccessKeyId}, CreateDate: ${key.CreateDate}"])}]
      EOM
      channel = param.slack_channel
    }
  }

  output "iam_users" {
    description = "List of all AWS IAM Users."
    value       = step.pipeline.list_iam_users.output.stdout
  }

  output "iam_access_keys_for_users" {
    description = "List of all AWS Access Keys for each user."
    value       = { for user, keys in step.pipeline.list_iam_access_keys_for_user : user => keys.output.stdout.AccessKeyMetadata }
  }

  output "new_access_keys" {
    description = "List of all AWS Access Keys that were created in the last 24 hours."
    value       = { for user, keys in step.transform.new_access_keys : user => keys.value }
  }
}

