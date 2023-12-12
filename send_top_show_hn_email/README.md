# Send Top "Show HN" Stories From Hacker News

Using [Steampipe](https://steampipe.io/) and the [Hacker News plugin](https://hub.steampipe.io/plugins/turbot/hackernews), list the top "Show HN" stories from Hacker News ordered by score and send them in an email using [SendGrid](https://sendgrid.com).

If run with `flowpipe server`, this mod will send an email every day at 12 PM UTC.

## Requirements

Install [Steampipe](https://steampipe.io/downloads) and the [Hacker News plugin](https://hub.steampipe.io/plugins/turbot/hackernews#get-started).

Then start Steampipe with `steampipe service start`.

## Credentials

By default, the following environment variables will be used for authentication:

- `SENDGRID_API_KEY`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/sendgrid.fpc
```

```hcl
credential "sendgrid" "default" {
  api_key = "SG.R6pHsRv..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

Run the pipeline to send an email immediately:

```sh
flowpipe pipeline run send_top_show_hn_email
```

To send an email at the scheduled time, start the Flowpipe server:

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
to   = "user@example.com"
from = "other.user@example.com"

# Optional
hn_story_count = "10"
```
