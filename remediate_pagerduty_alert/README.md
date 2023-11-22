# Remediate PagerDuty Alerts

Remediate PagerDuty alerts based on different event types such as triggered, annotated and acknowledged.

## Usage

- Add your PagerDuty API token to `flowpipe.pvars`
- Run the pipeline and specify `incident_id`, e.g., `flowpipe pipeline run remediate_pagerduty_alert --pipeline-arg 'incident_id=Q0AGCJ2OV4AV7'`
