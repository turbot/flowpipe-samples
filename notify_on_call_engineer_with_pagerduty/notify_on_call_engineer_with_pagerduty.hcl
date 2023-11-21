pipeline "notify_on_call_engineer_with_pagerduty" {
  title       = "Notify On-Call Engineer With PagerDuty"
  description = "Email an on-call engineer with PagerDuty."

  param "pagerduty_api_token" {
    type        = string
    description = "PagerDuty API token used for authentication."
    default     = var.pagerduty_api_token
  }

  param "sendgrid_api_key" {
    type        = string
    description = "SendGrid API key used for authentication."
    default     = var.sendgrid_api_key
  }

  param "slack_api_token" {
    type        = string
    description = "Slack app token used to authenticate to your Slack workspace."
    default     = var.slack_api_token
  }

  param "slack_message" {
    type        = string
    description = "The formatted text of the message to be published."
    default     = "Notification to the on-call Engineers"
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
    default     = var.slack_channel
  }

  param "email_subject" {
    type        = string
    description = "The global or 'message level' subject of your email. This may be overridden by subject lines set in personalizations."
  }

  param "email_text" {
    type        = string
    description = "The body of the email."
  }

  param "from" {
    type        = string
    description = "The 'From' email address used to deliver the message. This address should be a verified sender in your Twilio SendGrid account."
  }

  # List all on-call users
  step "pipeline" "list_on_calls" {
    pipeline = pagerduty.pipeline.list_on_calls
    args = {
      api_key = param.pagerduty_api_token
    }
  }

  # Get details of all on-call users
  step "pipeline" "list_all_on_call_user_details" {
    for_each = distinct([for oncall in step.pipeline.list_on_calls.output.on_calls.oncalls : oncall.user.id])
    pipeline = pagerduty.pipeline.get_user
    args = {
      api_key = param.pagerduty_api_token
      user_id = each.value
    }
  }

  # Send slack message to the on-call channel
  step "pipeline" "post_message_in_slack" {
    depends_on = [step.pipeline.list_all_on_call_user_details]
    pipeline   = slack.pipeline.post_message
    args = {
      token   = param.slack_api_token
      channel = param.slack_channel
      message = "${param.slack_message}: ${join(", ", [for key, value in step.pipeline.list_all_on_call_user_details : value.output.user.user.email])}"
    }
  }

  # Send mails to on-call users
  step "pipeline" "send_email" {
    depends_on = [step.pipeline.list_all_on_call_user_details]
    for_each   = { for key, value in step.pipeline.list_all_on_call_user_details : key => value.output.user.user.email }
    pipeline   = sendgrid.pipeline.send_email
    args = {
      api_key = param.sendgrid_api_key
      to      = each.value
      from    = param.from
      subject = param.email_subject
      text    = param.email_text
    }
  }
}
