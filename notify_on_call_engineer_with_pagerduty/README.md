# Notify On-Call Engineer With PagerDuty

Allows anyone to see who is on-call for a particular escalation policy, send them an email, notify a Slack channel.

## Credentials

By default, the following environment variables will be used for authentication:

- `PAGERDUTY_TOKEN`
- `SENDGRID_API_KEY`
- `SLACK_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/pagerduty.fpc
```

```hcl
credential "pagerduty" "pagerduty_cred" {
  api_key = "u+_szhL..."
}
```

```sh
vi ~/.flowpipe/config/sendgrid.fpc
```

```hcl
credential "sendgrid" "default" {
  api_key = "SG.R6pHsRv..."
}
```

```sh
vi ~/.flowpipe/config/slack.fpc
```

```hcl
credential "slack" "default" {
  token = "xoxp-12345-..."
}
```

## Usage

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

Run the pipeline and specify the `slack_message`, `slack_channel`, `email_subject`, `email_text` and `from` pipeline arguments:

```sh
flowpipe pipeline run notify_on_call_engineer_with_pagerduty \
  --arg slack_message="On-call engineer" \
  --arg slack_channel="CH12345ABC" \
  --arg email_subject="On-call engineer" \
  --arg email_text="On-call engineer" \
  --arg from="foo@bar.com"
```
