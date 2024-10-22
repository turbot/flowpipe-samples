trigger "http" "pagerduty_webhook_incident_events" {
  title       = "PagerDuty Webhook Incident Events"
  description = "Take remediation actions based on the incident event type."

  pipeline = pipeline.remediate_pagerduty_alert
  args = {
    event = jsondecode(self.request_body).event
  }
}

pipeline "remediate_pagerduty_alert" {
  title       = "Remediate PagerDuty Alert"
  description = "Takes Remediation Actions based on the event."

  tags = {
    recommended = "true"
  }

  param "pagerduty_conn" {
    type        = connection.pagerduty
    description = "Name of PagerDuty connection to use. If not provided, the default PagerDuty connection will be used."
    default     = connection.pagerduty.default
  }

  param "event" {
    type        = any
    description = "PagerDuty event."
  }

  step "pipeline" "pagerduty_incident_acknowledged" {
    if       = param.event.event_type == "incident.acknowledged"
    pipeline = pipeline.pagerduty_incident_acknowledged
    args = {
      pagerduty_conn = param.pagerduty_conn
      incident_id    = param.event.data.id
    }
  }

  step "pipeline" "pagerduty_incident_triggered" {
    if       = param.event.event_type == "incident.triggered"
    pipeline = pipeline.pagerduty_incident_triggered
    args = {
      pagerduty_conn = param.pagerduty_conn
      incident_id    = param.event.data.id
    }
  }

  step "pipeline" "pagerduty_incident_annotated" {
    if       = param.event.event_type == "incident.annotated"
    pipeline = pipeline.pagerduty_incident_annotated
    args = {
      pagerduty_conn = param.pagerduty_conn
      incident_id    = param.event.data.incident.id
    }
  }


  output "remediate_pagerduty_alert" {
    description = "The remediation action taken."
    value = {
      pagerduty_incident_acknowledged : step.pipeline.pagerduty_incident_acknowledged,
      pagerduty_incident_triggered : step.pipeline.pagerduty_incident_triggered,
      pagerduty_incident_annotated : step.pipeline.pagerduty_incident_annotated
    }
  }
}
