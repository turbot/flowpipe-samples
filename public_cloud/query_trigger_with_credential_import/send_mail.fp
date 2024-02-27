pipeline "send_email" {
  description     = "Send an email using the built-in email step"
  param "smtp_username" { type = string }
  param "smtp_host"     { type = string }
  param "subject"       { type = string }
  param "message"       { type = string }

  step "email" "send_it" {
    to            = ["${param.smtp_username}"]
    from          = "${param.smtp_username}"
    smtp_username = "${param.smtp_username}"
    smtp_password = env("FLOWPIPE_EMAIL_APP_PW")
    host          = "${param.smtp_host}"
    port          = 587
    subject       = "${param.subject}"
    content_type  = "text/html"
    body          = "${param.message}"
  }
}


