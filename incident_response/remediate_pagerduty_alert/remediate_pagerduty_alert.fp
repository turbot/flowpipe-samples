trigger "http" "pagerduty_webhook_incident_events" {
  title       = "PagerDuty Webhook Incident Events"
  description = "Webhook for PagerDuty incident events."

  pipeline = pipeline.remediate_pagerduty_alert
  args = {
    event = jsondecode(self.request_body).event
  }
}

pipeline "remediate_pagerduty_alert" {
  title       = "Remediate PagerDuty Alert"
  description = "Remediate PagerDuty alert."

  param "event" {
    type        = any
    description = "PagerDuty event."
  }

  step "pipeline" "pagerduty_incident_acknowledged" {
    if       = param.event.event_type == "incident.acknowledged"
    pipeline = pipeline.pagerduty_incident_acknowledged
    args = {
      incident_id = param.event.data.id
    }
  }

  step "pipeline" "pagerduty_incident_triggered" {
    if       = param.event.event_type == "incident.triggered"
    pipeline = pipeline.pagerduty_incident_triggered
    args = {
      incident_id = param.event.data.id
    }
  }

  step "pipeline" "pagerduty_incident_annotated" {
    if       = param.event.event_type == "incident.annotated"
    pipeline = pipeline.pagerduty_incident_annotated
    args = {
      incident_id = param.event.data.incident.id
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
