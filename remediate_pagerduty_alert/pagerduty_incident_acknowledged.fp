pipeline "pagerduty_incident_acknowledged" {
  title       = "PagerDuty Incident Acknowledged"
  description = "PagerDuty incident acknowledged."

  param "pagerduty_api_token" {
    type        = string
    description = "PagerDuty API token used for authentication."
    default     = var.pagerduty_api_token
  }

  param "incident_id" {
    type        = string
    description = "The ID of the incident."
  }

  # PagerDuty Get Current User
  step "pipeline" "get_current_user" {
    pipeline = pagerduty.pipeline.get_current_user
    args = {
      api_key = param.pagerduty_api_token
    }
  }

  # Update Incident status
  step "pipeline" "update_incident_status" {
    depends_on = [step.pipeline.get_current_user]
    pipeline   = pagerduty.pipeline.create_status_update_on_incident
    args = {
      api_key     = param.pagerduty_api_token
      from        = step.pipeline.get_current_user.output.current_user.user.email
      incident_id = param.incident_id
      message     = "Acknowledged"
    }
  }

  # Create a Note For The Incident
  step "pipeline" "create_note_on_incident" {
    depends_on = [step.pipeline.update_incident_status]
    pipeline   = pagerduty.pipeline.create_note_on_incident
    args = {
      api_key     = param.pagerduty_api_token
      from        = step.pipeline.get_current_user.output.current_user.user.email
      incident_id = param.incident_id
      content     = "The incident is acknowledged by ${step.pipeline.get_current_user.output.current_user.user.name}"
    }
  }

  output "pagerduty_incident_acknowledged" {
    value = {
      create_note_on_incident : step.pipeline.create_note_on_incident.output.create_note_on_incident,
      update_incident_status : step.pipeline.update_incident_status.output.create_status_update_on_incident
    }
  }
}
