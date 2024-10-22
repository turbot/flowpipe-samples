pipeline "notify_on_call_engineer_with_pagerduty" {
  title       = "Notify On-Call Engineer With PagerDuty"
  description = "Allows anyone to see who is on-call for a particular escalation policy, send them an email, notify a Slack channel."

  tags = {
    recommended = "true"
  }

  param "pagerduty_conn" {
    type        = connection.pagerduty
    description = "Name of PagerDuty connection to use. If not provided, the default PagerDuty connection will be used."
    default     = connection.pagerduty.default
  }

  param "slack_conn" {
    type        = connection.slack
    description = "Name of Slack connection to use. If not provided, the default Slack connection will be used."
    default     = connection.slack.default
  }

  param "sendgrid_conn" {
    type        = connection.sendgrid
    description = "Name of SendGrid connection to use. If not provided, the default SendGrid connection will be used."
    default     = connection.sendgrid.default
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
      conn = param.pagerduty_conn
    }
  }

  # Get details of all on-call users
  step "pipeline" "list_all_on_call_user_details" {
    for_each = distinct([for oncall in step.pipeline.list_on_calls.output.on_calls : oncall.user.id])

    pipeline = pagerduty.pipeline.get_user
    args = {
      conn    = param.pagerduty_conn
      user_id = each.value
    }
  }

  # Send slack message to the on-call channel
  step "pipeline" "post_message_in_slack" {
    depends_on = [step.pipeline.list_all_on_call_user_details]

    pipeline = slack.pipeline.post_message
    args = {
      conn    = param.slack_conn
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
      conn    = param.sendgrid_conn
      to      = each.value
      from    = param.from
      subject = param.email_subject
      content = param.email_text
    }
  }
}
