# Remediate PagerDuty Alert

Take remediation actions based on the incident event type.

If run with `flowpipe server`, this mod will receive a PagerDuty v3 webhook when an incident is triggered, annotated, and acknowledged.

## Getting Started

### Credentials

By default, the following environment variables will be used for authentication:

- `PAGERDUTY_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/pagerduty.fpc
```

```hcl
credential "pagerduty" "pagerduty_cred" {
  api_key = "u+_szhL....."
}
```

### Usage

Run the pipeline to take action for PagerDuty incident acknowledged:

```sh
flowpipe pipeline run pagerduty_incident_acknowledged --arg incident_id=<incident_id>
```

To run whenever an incident is triggered, annotated, and acknowledged, start the Flowpipe server:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically whenever a webhook is received.

### Configuration

To run the pipeline automatically whenever a webhook is received, you can set the [PagerDuty v3 webhook](https://developer.pagerduty.com/docs/db0fa8c8984fc-overview#webhook-subscriptions). 

For the webhook URL:

1. List the triggers in the top level (parent mod), 
  ```ssh
  flowpipe trigger list
  ```
2. Copy the `url` for the `remediate_pagerduty_alert.trigger.http.pagerduty_webhook_incident_events` trigger
3. Use ngrok to expose the webhook URL to the internet
  ```ssh
  ngrok http 7103
  ```
4. With the public endpoint from ngrok and the hook url, form the webhook URL for the trigger with the format `https://{ngrok-domain}.ngrok-free.app/api/v0/{hook-url}`