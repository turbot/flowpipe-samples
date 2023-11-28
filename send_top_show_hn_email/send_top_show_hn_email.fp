trigger "schedule" "send_top_show_hn_email" {
  description = "Send an email every day at 12 PM UTC that shows Hacker News trending stories."
  schedule = "0 12 * * *"
  pipeline = pipeline.send_top_show_hn_email
}

pipeline "send_top_show_hn_email" {
  title       = "Send Email with Top 'Show HN'"
  description = "Send an email using SendGrid containing top stories from 'Show HN'."

  param "sendgrid_api_key" {
    type        = string
    description = "SendGrid API key used for authentication."
    default     = var.sendgrid_api_key
  }

  param "hn_story_count" {
    type        = number
    description = "The number of stories to retrieve from Hacker News."
    default     = 50
  }

  param "to" {
    type        = string
    description = "The intended recipient's email address."
  }

  param "from" {
    type        = string
    description = "The 'From' email address used to deliver the message. This address should be a verified sender in your Twilio SendGrid account."
  }

  step "query" "list_show_hn_stories" {
    connection_string = "postgres://steampipe@localhost:9193/steampipe"
    sql = <<-EOQ
      select
        by,
        score,
        text,
        title,
        url
      from
        hackernews_show_hn
      order by
        score desc
      limit ${param.hn_story_count}
    EOQ
  }

  step "pipeline" "send_email" {
    pipeline = sendgrid.pipeline.send_email
    args = {
      api_key = param.sendgrid_api_key
      to      = param.to
      from    = param.from
      subject = "Top ${param.hn_story_count} Show HN stories on ${timestamp()}"
      text    = length(step.query.list_show_hn_stories.rows) > 0 ? "Top ${param.hn_story_count} Show HN stories:\n\n${join("", [for story in step.query.list_show_hn_stories.rows : format("%v\n%v score by %v\n%v}\n%v\n\n", story.title, story.score, story.by, story.url, story.text)])}" : "No stories available."
    }
  }

  // Re-enable for debugging
  /*
  output "hn_stories" {
    value = step.query.list_show_hn_stories.rows
  }
  */

  output "send_email_check" {
    value = !is_error(step.pipeline.send_email) ? "Email sent successfully" : "Error sending email: ${error_message(step.pipeline.send_email)}"
  }
}
