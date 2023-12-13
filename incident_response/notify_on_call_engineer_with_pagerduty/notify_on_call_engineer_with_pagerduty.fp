pipeline "notify_on_call_engineer_with_pagerduty" {
  title       = "Notify On-Call Engineer With PagerDuty"
  description = "Notify an on-call engineer with PagerDuty."

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
  }

  # Get details of all on-call users
  step "pipeline" "list_all_on_call_user_details" {
    for_each = distinct([for oncall in step.pipeline.list_on_calls.output.on_calls : oncall.user.id])
    pipeline = pagerduty.pipeline.get_user
    args = {
      user_id = each.value
    }
  }

  # Send slack message to the on-call channel
  step "pipeline" "post_message_in_slack" {
    depends_on = [step.pipeline.list_all_on_call_user_details]
    pipeline   = slack.pipeline.post_message
    args = {
      channel = param.slack_channel
      text    = "${param.slack_message}: ${join(", ", [for key, value in step.pipeline.list_all_on_call_user_details : value.output.user.email])}"
    }
  }

  # Send mails to on-call users
  step "pipeline" "send_email" {
    depends_on = [step.pipeline.list_all_on_call_user_details]
    for_each   = { for key, value in step.pipeline.list_all_on_call_user_details : key => value.output.user.email }
    pipeline   = sendgrid.pipeline.mail_send
    args = {
      to      = each.value
      from    = param.from
      subject = param.email_subject
      content = param.email_text
    }
  }
}
