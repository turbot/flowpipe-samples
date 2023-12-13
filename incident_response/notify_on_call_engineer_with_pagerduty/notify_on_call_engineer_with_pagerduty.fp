pipeline "notify_on_call_engineer_with_pagerduty" {
  title       = "Notify On-Call Engineer With PagerDuty"
  description = "Allows anyone to see who is on-call for a particular escalation policy, send them an email, notify a Slack channel."

  tags = {
    type = "featured"
  }

  param "pagerduty_cred" {
    type        = string
    description = "Name for PagerDuty credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "slack_cred" {
    type        = string
    description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "sendgrid_cred" {
    type        = string
    description = "Name for SendGrid credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "slack_message" {
    type        = string
    description = "The formatted text of the message to be published."
    default     = "Notification to the on-call Engineers"
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
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
      cred = param.pagerduty_cred
    }
  }

  # Get details of all on-call users
  step "pipeline" "list_all_on_call_user_details" {
    for_each = distinct([for oncall in step.pipeline.list_on_calls.output.on_calls : oncall.user.id])

    pipeline = pagerduty.pipeline.get_user
    args = {
      cred    = param.pagerduty_cred
      user_id = each.value
    }
  }

  # Send slack message to the on-call channel
  step "pipeline" "post_message_in_slack" {
    depends_on = [step.pipeline.list_all_on_call_user_details]

    pipeline = slack.pipeline.post_message
    args = {
      cred    = param.slack_cred
      channel = param.slack_channel
      text    = "${param.slack_message}: ${join(", ", [for key, value in step.pipeline.list_all_on_call_user_details : value.output.user.email])}"
    }
  }

  # Send mails to on-call users
  step "pipeline" "send_email" {
    depends_on = [step.pipeline.list_all_on_call_user_details]
    for_each   = { for key, value in step.pipeline.list_all_on_call_user_details : key => value.output.user.email }

    pipeline = sendgrid.pipeline.send_mail
    args = {
      cred    = param.sendgrid_cred
      to      = each.value
      from    = param.from
      subject = param.email_subject
      content = param.email_text
    }
  }
}
