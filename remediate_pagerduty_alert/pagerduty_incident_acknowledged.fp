pipeline "pagerduty_incident_acknowledged" {
  title       = "PagerDuty Incident Acknowledged"
  description = "Takes remediation action for PagerDuty incident 'acknowledged'."

  param "pagerduty_cred" {
    type        = string
    description = "Name for PagerDuty credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "incident_id" {
    type        = string
    description = "The ID of the incident."
  }

  # PagerDuty Get Current User
  step "pipeline" "get_current_user" {
    pipeline = pagerduty.pipeline.get_current_user
    args = {
      cred = param.pagerduty_cred
    }
  }

  # Update Incident status
  step "pipeline" "update_incident_status" {
    depends_on = [step.pipeline.get_current_user]

    pipeline = pagerduty.pipeline.create_status_update_on_incident
    args = {
      cred        = param.pagerduty_cred
      from        = step.pipeline.get_current_user.output.user.email
      incident_id = param.incident_id
      message     = "Acknowledged"
    }
  }

  # Create a Note For The Incident
  step "pipeline" "create_note_on_incident" {
    depends_on = [step.pipeline.update_incident_status]

    pipeline = pagerduty.pipeline.create_note_on_incident
    args = {
      cred        = param.pagerduty_cred
      from        = step.pipeline.get_current_user.output.user.email
      incident_id = param.incident_id
      content     = "The incident is acknowledged by ${step.pipeline.get_current_user.output.user.name}"
    }
  }

  output "pagerduty_incident_acknowledged" {
    description = "The incident acknowledged details."
    value       = step.pipeline.update_incident_status.output.status_update
  }

  output "note" {
    description = "The note created on the incident with type 'acknowledged'."
    value       = step.pipeline.create_note_on_incident
  }
}
