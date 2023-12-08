# Send Top "Show HN" Stories From Hacker News

Using [Steampipe](https://steampipe.io/) and the [Hacker News plugin](https://hub.steampipe.io/plugins/turbot/hackernews), list the top "Show HN" stories from Hacker News ordered by score and send them in an email using [SendGrid](https://sendgrid.com).

If run with `flowpipe server`, this mod will send an email every day at 12 PM UTC.

## Usage

- Install [Steampipe](https://steampipe.io/downloads) and the [Hacker News plugin](https://hub.steampipe.io/plugins/turbot/hackernews#get-started)
- Start Steampipe with `steampipe service start`
- Set your `SENDGRID_API_KEY` environment variable or configure your SendGrid credentials in `~/.flowpipe/config/sendgrid.fpc`:
  ```hcl
  credential "sendgrid" "default" {
    api_key="SG.R6pHsRv..."
  }
  ```
- Test your credentials by running the pipeline, e.g., `flowpipe pipeline run send_top_show_hn_email`
  - You can also specify the number of stories, e.g., `flowpipe pipeline run send_top_show_hn_email --var 'hn_story_count=10'`
- Run `flowpipe server` to start the Flowpipe server, which will then automatically run the pipeline to send an email every day at the scheduled time
