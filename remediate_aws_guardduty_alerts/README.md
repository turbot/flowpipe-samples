# Remediate AWS Guard Duty Alerts

Automate AWS SNS notifications from Guard Duty Findings triggering Jira issue creation, execute actions in AWS for identified issues, and update issue state to "done" upon resolution.AWS GuardDuty alerts based on different event types triggered.

## Usage

- Add your AWS credentials to `flowpipe.pvars`
- Add your Jira credentials to `flowpipe.pvars`
- Run the pipeline `flowpipe pipeline run remediate_aws_guardduty_alerts`
