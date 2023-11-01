// TODO: Delete this pipeline once mod install works
pipeline "sendgrid_send_email" {
  title       = "Send Mail"
  description = "Send an email using SendGrid."

  param "api_key" {
    type        = string
    default     = var.sendgrid_api_key
    description = "SendGrid API key used for authentication."
  }

  param "to" {
    type        = string
    description = "The intended recipient's email address."
  }

  param "from" {
    type        = string
    description = "The 'From' email address used to deliver the message. This address should be a verified sender in your Twilio SendGrid account."
  }

  param "subject" {
    type        = string
    description = "The global or 'message level' subject of your email. This may be overridden by subject lines set in personalizations."
  }

  param "text" {
    type        = string
    description = "The body of the email."
  }

  step "http" "send_email" {
    title  = "Send an email"
    method = "post"
    url    = "https://api.sendgrid.com/v3/mail/send"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.api_key}"
    }

    request_body = jsonencode({
      "personalizations" : [
        {
          "to" : [{ "email" : "${param.to}" }]
        }
      ],
      "subject" : "${param.subject}",
      "content" : [
        {
          "type" : "text/plain",
          "value" : "${param.text}"
        }
      ],
      "from" : {
        "email" : "${param.from}"
      }
    })
  }

}
