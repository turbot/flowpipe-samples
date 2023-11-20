pipeline "remediate_pagerduty_alert" {
  title       = "Remediate PagerDuty Alert"
  description = "Remediate PagerDuty alert."

  param "pagerduty_api_token" {
    type        = string
    description = "PagerDuty API token used for authentication."
    default     = var.pagerduty_api_token
  }

  param "incident_id" {
    type        = string
    description = "The ID of the incident."
  }

  step "pipeline" "list_incident_log_entries" {
    pipeline = pagerduty.pipeline.list_incident_log_entries
    args = {
      api_key     = param.pagerduty_api_token
      incident_id = param.incident_id
    }
  }

  step "pipeline" "pagerduty_incident_acknowledged" {
    if       = step.pipeline.list_incident_log_entries.output.incident_log_entries.log_entries[0].type == "acknowledge_log_entry"
    pipeline = pipeline.pagerduty_incident_acknowledged
    args = {
      api_key     = param.pagerduty_api_token
      incident_id = param.incident_id
    }
  }

  step "pipeline" "pagerduty_incident_triggered" {
    if       = step.pipeline.list_incident_log_entries.output.incident_log_entries.log_entries[0].type == "trigger_log_entry"
    pipeline = pipeline.pagerduty_incident_triggered
    args = {
      api_key     = param.pagerduty_api_token
      incident_id = param.incident_id
    }
  }

  step "pipeline" "pagerduty_incident_annotated" {
    if       = step.pipeline.list_incident_log_entries.output.incident_log_entries.log_entries[0].type == "annotate_log_entry"
    pipeline = pipeline.pagerduty_incident_annotated
    args = {
      api_key     = param.pagerduty_api_token
      incident_id = param.incident_id
    }
  }


  output "remediate_pagerduty_alert" {
    value = {
      pagerduty_incident_acknowledged : step.pipeline.pagerduty_incident_acknowledged,
      pagerduty_incident_triggered : step.pipeline.pagerduty_incident_triggered,
      pagerduty_incident_annotated : step.pipeline.pagerduty_incident_annotated
    }
  }
}
