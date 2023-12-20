# Notify On-Call Engineer With PagerDuty

Allows anyone to see who is on-call for a particular escalation policy, send them an email, notify a Slack channel.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd incident_response/notify_on_call_engineer_with_pagerduty
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

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

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the `slack_message`, `slack_channel`, `email_subject`, `email_text` and `from` pipeline arguments:

```sh
flowpipe pipeline run notify_on_call_engineer_with_pagerduty \
  --arg slack_message="On-call engineer" \
  --arg slack_channel="CH12345ABC" \
  --arg email_subject="On-call engineer" \
  --arg email_text="On-call engineer" \
  --arg from="foo@bar.com"
```
