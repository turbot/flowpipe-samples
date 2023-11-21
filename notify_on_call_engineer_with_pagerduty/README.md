# Notify On-Call Engineer With PagerDuty

Allows anyone to see who is on-call for a particular escalation policy, send them an email, notify a Slack channel.

## Usage

- Add your PagerDuty, SendGrid, Slack API key to `flowpipe.pvars`
- Run the pipeline and specify `slack_message` and `slack_channel`, e.g., `flowpipe pipeline run notify_on_call_engineer_with_pagerduty --pipeline-arg 'slack_message="Notification for on-call' --pipeline-arg 'slack_channel=C1234567890'`
