trigger "schedule" "slack_scanner" {
  description = "A daily cron job at 9 AM UTC that checks for secrets in Slack Channel."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.slack_scanner
}

pipeline "slack_scanner" {
  title       = "Slack Scanner"
  description = "Scan secrets and sensitive information on Slack."

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
    default     = var.channel
  }

  step "container" "last_24hr_in_epoch" {
    image = "alpine"
    cmd   = ["sh", "-c", "current_timestamp=$(date +%s);twenty_four_hours_ago=$((current_timestamp - 86400));echo -n $twenty_four_hours_ago"]
  }

  step "pipeline" "slack_get_channel_history" {
    pipeline = slack.pipeline.get_channel_history
    args = {
      token   = var.slack_token
      channel = param.slack_channel
      oldest  = step.container.last_24hr_in_epoch.stdout # Get the messages for the last 24 hours
    }
  }

  step "transform" "slack_check_secrets" {
    for_each = [for message in step.pipeline.slack_get_channel_history.output.channel_history : message
      if message.type == "message"
    ]
    value = {
      message_text = each.value.text
      message_ts   = each.value.ts
      secrets      = join(", ", [for secret, pattern in local.secrets_regex : secret if length(regexall(pattern, each.value.text)) > 0])
      user         = each.value.user
    }
  }

  step "pipeline" "slack_get_message_link" {
    for_each = [
      for secret in step.transform.slack_check_secrets : secret.value.message_ts
      if secret.value.secrets != ""
    ]
    pipeline = slack.pipeline.get_message_permalink
    args = {
      channel    = param.slack_channel
      message_ts = each.value
    }
  }

  step "pipeline" "slack_post_direct_message" {
    for_each = [
      for secret in step.transform.slack_check_secrets : secret.value
      if secret.value.secrets != ""
    ]
    pipeline = slack.pipeline.post_message
    args = {
      channel = each.value.user
      message = "Secrets detected:\n\tType: ${each.value.secrets}\n\tSlack channel: ${param.slack_channel}\n\tURL: ${step.pipeline.slack_get_message_link[each.key].output.permalink}"
    }
  }
}
