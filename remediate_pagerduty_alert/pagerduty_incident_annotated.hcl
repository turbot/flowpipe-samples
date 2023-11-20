pipeline "pagerduty_incident_annotated" {
  title       = "PagerDuty Incident Annotated"
  description = "PagerDuty incident annotated."

  param "pagerduty_api_token" {
    type        = string
    description = "PagerDuty API token used for authentication."
    default     = var.pagerduty_api_token
  }

  param "incident_id" {
    type        = string
    description = "The ID of the incident."
  }

  step "pipeline" "list_incident_notes" {
    pipeline = pagerduty.pipeline.list_incident_notes
    args = {
      api_key     = param.pagerduty_api_token
      incident_id = param.incident_id
    }
  }

  # Really Free Geo IP
  step "pipeline" "geo_lookup_ip" {
    for_each = { for ip in distinct(flatten([
      for note in step.pipeline.list_incident_notes.output.list_incident_notes.notes :
      regexall("\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b", note.content)
    ])) : ip => ip }
    pipeline = reallyfreegeoip.pipeline.check_ip
    args = {
      ip_address = each.value
    }
  }

  # PagerDuty Get Current User
  step "pipeline" "get_current_user" {
    if       = step.pipeline.geo_lookup_ip != {}
    pipeline = pagerduty.pipeline.get_current_user
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
      from        = step.pipeline.get_current_user.output.user.user.email
      incident_id = param.incident_id
      content     = jsonencode(step.pipeline.geo_lookup_ip)
    }
  }

  output "pagerduty_incident_annotated" {
    value = step.pipeline.create_note_on_incident
  }
}
