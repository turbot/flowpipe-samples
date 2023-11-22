pipeline "pagerduty_incident_triggered" {
  title       = "PagerDuty Incident Triggered"
  description = "PagerDuty incident triggered."

  param "pagerduty_api_token" {
    type        = string
    description = "PagerDuty API token used for authentication."
    default     = var.pagerduty_api_token
  }

  param "incident_id" {
    type        = string
    description = "The ID of the incident."
  }

  step "pipeline" "get_incident" {
    pipeline = pagerduty.pipeline.get_incident
    args = {
      api_key     = param.pagerduty_api_token
      incident_id = param.incident_id
    }
  }

  # Really Free Geo IP
  step "pipeline" "geo_lookup_ip" {
    for_each = { for ip in distinct(regexall("\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b", step.pipeline.get_incident.output.incident.incident.summary)) : ip => ip }
    pipeline = reallyfreegeoip.pipeline.check_ip
    args = {
      ip_address = each.value
    }
  }

  # PagerDuty Get Current User
  step "pipeline" "get_current_user" {
    depends_on = [step.pipeline.geo_lookup_ip]
    if         = step.pipeline.geo_lookup_ip != {}
    pipeline   = pagerduty.pipeline.get_current_user
    args = {
      api_key = param.pagerduty_api_token
    }
  }

  # Create a Note For The Incident
  step "pipeline" "create_note_on_incident" {
    depends_on = [step.pipeline.get_current_user]
    if         = step.pipeline.geo_lookup_ip != {}
    pipeline   = pagerduty.pipeline.create_note_on_incident
    args = {
      api_key     = param.pagerduty_api_token
      from        = step.pipeline.get_current_user.output.current_user.user.email
      incident_id = param.incident_id
      content     = jsonencode(step.pipeline.geo_lookup_ip)
    }
  }

  output "pagerduty_incident_triggered" {
    value = step.pipeline.create_note_on_incident
  }
}
