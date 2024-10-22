pipeline "pagerduty_incident_annotated" {
  title       = "PagerDuty Incident Annotated"
  description = "Takes remediation action for PagerDuty incident 'annotated'."

  param "pagerduty_conn" {
    type        = connection.pagerduty
    description = "Name of PagerDuty connection to use. If not provided, the default PagerDuty connection will be used."
    default     = connection.pagerduty.default
  }

  param "incident_id" {
    type        = string
    description = "The ID of the incident."
  }

  step "pipeline" "list_incident_notes" {
    pipeline = pagerduty.pipeline.list_incident_notes
    args = {
      conn        = param.pagerduty_conn
      incident_id = param.incident_id
    }
  }

  # Really Free Geo IP
  step "pipeline" "geo_lookup_ip" {
    for_each = { for ip in distinct(flatten([
      for note in step.pipeline.list_incident_notes.output.notes :
      regexall("\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b", note.content)
    ])) : ip => ip }

    pipeline = reallyfreegeoip.pipeline.get_ip_geolocation
    args = {
      ip_address = each.value
    }
  }

  # PagerDuty Get Current User
  step "pipeline" "get_current_user" {
    if = step.pipeline.geo_lookup_ip != {}

    pipeline = pagerduty.pipeline.get_current_user
    args = {
      conn = param.pagerduty_conn
    }
  }

  # Create a Note For The Incident
  step "pipeline" "create_note_on_incident" {
    depends_on = [step.pipeline.get_current_user]
    if         = step.pipeline.geo_lookup_ip != {}

    pipeline = pagerduty.pipeline.create_note_on_incident
    args = {
      conn        = param.pagerduty_conn
      from        = step.pipeline.get_current_user.output.user.email
      incident_id = param.incident_id
      content     = jsonencode(step.pipeline.geo_lookup_ip)
    }
  }

  output "note" {
    description = "The note created on the incident with type 'annotated'."
    value       = step.pipeline.create_note_on_incident
  }
}
