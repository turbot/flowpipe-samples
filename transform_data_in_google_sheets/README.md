# Send Top "Show HN" Stories From Hacker News

Send an email every day at 12 PM UTC showing the top "Show HN" stories from Hacker News ordered by score.

## Usage

- Add your SendGrid API key to `flowpipe.pvars`
- Run the pipeline and specify `to` and `from`, e.g., `flowpipe pipeline run send_top_show_hn_email --pipeline-arg 'to=foo@example.com' --pipeline-arg 'from=bar@example.com'`
- You can specify the number of stories with `--pipeline-arg hn_story_count=10`
