pipeline "lookup_email" {
  title       = "Lookup Email in Different Tools"
  description = "A composite Flowpipe mod that lookup email in VirusTotal, Urlscan and other tools."

  param "hunter_api_key" {
    type        = string
    default     = var.hunter_api_key
    description = local.hunter_api_key_param_description
  }

  param "kickbox_api_key" {
    type        = string
    default     = var.kickbox_api_key
    description = local.kickbox_api_key_param_description
  }

  param "email" {
    type        = string
    description = "The email ID to be scanned."
  }

  # Hunter
  step "http" "hunter" {
    method = "get"
    url    = "https://api.hunter.io/v2/email-verifier?email=${param.email}&api_key=${param.hunter_api_key}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  # Kickbox
  step "http" "kickbox" {
    method = "get"
    url    = "https://api.kickbox.com/v2/verify?email=${param.email}&apikey=${param.kickbox_api_key}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  step "echo" "lookup_email" {
    json = {
      hunter_email_verify_status : step.http.hunter.response_body.data,
      kickbox_email_verify_status : step.http.kickbox.response_body,
    }
  }

  output "lookup_email" {
    value = step.echo.lookup_email.json
  }
}