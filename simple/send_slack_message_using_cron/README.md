# Send Slack Message Using Cron

Send a message to a Slack channel every minute using cron.

If run with `flowpipe server`, this mod will send a message to slack every minute.

## Credentials

By default, the following environment variables will be used for authentication:

- `SLACK_TOKEN`

You can also create `credential` resources in configuration files:

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

Run the pipeline to send a message immediately:

```sh
flowpipe pipeline run send_slack_message_using_cron --arg channel=CH1234FEW --arg text="Hello!"
```

To send a message at the scheduled time, start the Flowpipe server:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically at the scheduled time.

## Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Required
channel = "CH1234FEW"
text    = "Hello!"

# Optional
# slack_cred = "non_default_cred"
```
