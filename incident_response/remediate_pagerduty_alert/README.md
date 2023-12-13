# Remediate PagerDuty Alert

Take remediation actions based on the incident event type.

If run with `flowpipe server`, this mod will receive a [PagerDuty v3 webhook event](https://developer.pagerduty.com/docs/db0fa8c8984fc-overview) when an incident is triggered, annotated, and acknowledged.

## Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd incident_response/remediate_pagerduty_alert
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `PAGERDUTY_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/pagerduty.fpc
```

```hcl
credential "pagerduty" "pagerduty_cred" {
  api_key = "u+_szhL..."
}
```

## Usage

Run the pipeline to take action for PagerDuty incident acknowledged:

```sh
flowpipe pipeline run pagerduty_incident_acknowledged --arg incident_id=PT4KHLK
```

To run whenever an incident is triggered, annotated, and acknowledged, start the Flowpipe server:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically whenever a webhook event is received.

## Configuration

To run the pipeline automatically whenever a webhook event is received, you can create a PagerDuty webhook subscription.

To configure the webhook subscription in PagerDuty:

1. Get the trigger details:
  ```sh
  flowpipe trigger show http.pagerduty_webhook_incident_events
  ```
2. Copy the `Url`, e.g., `/hook/remediate_pagerduty_alert.trigger.http.pagerduty_webhook_incident_events/92ffeda03426754f2c79dfaa`
3. Use a tool like [ngrok](https://ngrok.com/) with a custom domain to expose your localhost server to the internet:
  ```sh
  ngrok http 7103 --domain=yellow-neutral-lab.ngrok-free.app
  ```
4. Form the full webhook URL with the public endpoint from ngrok and the trigger URL using the format `https://{ngrok_domain}.ngrok-free.app/api/v0/{hook_url}`, e.g., `https://yellow-neutral-lab.ngrok-free.app/api/v0/hook/remediate_pagerduty_alert.trigger.http.pagerduty_webhook_incident_events/92ffeda03426754f2c79dfaa`
5. Create the webhook subscription in PagerDuty with the following configurations:
   - Webhook URL: `<URL from above>`
   - Scope Type: Account
   - Description: Flowpipe webhook trigger
   - Event Subscription:
     - incident.acknowledged
     - incident.triggered
     - incident.annotated
