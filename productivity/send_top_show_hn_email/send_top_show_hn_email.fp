trigger "schedule" "send_top_show_hn_email" {
  title       = "Schedule Send Email with Top 'Show HN'"
  description = "Send an email every day at 12 PM UTC that shows Hacker News trending stories."
  schedule    = "0 12 * * *"
  pipeline    = pipeline.send_top_show_hn_email
}

pipeline "send_top_show_hn_email" {
  title       = "Send Email with Top 'Show HN'"
  description = "Send an email using SendGrid containing top stories from 'Show HN'."

  tags = {
    type = "featured"
  }

  param "sendgrid_cred" {
    type        = string
    description = "Name for SendGrid credentials to use. If not provided, the default credentials will be used."
    default     = var.sendgrid_cred
  }

  param "hn_story_count" {
    type        = number
    description = "The number of stories to retrieve from Hacker News."
    default     = var.hn_story_count
  }

  param "to" {
    type        = string
    description = "The intended recipient's email address."
    default     = var.to
  }

  param "from" {
    type        = string
    description = "The 'From' email address used to deliver the message. This address should be a verified sender in your Twilio SendGrid account."
    default     = var.from
  }

  step "query" "list_show_hn_stories" {
    database = "postgres://steampipe@localhost:9193/steampipe"

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

  step "pipeline" "send_mail" {
    pipeline = sendgrid.pipeline.send_mail
    args = {
      cred    = param.sendgrid_cred
      to      = param.to
      from    = param.from
      subject = "Top ${param.hn_story_count} Show HN stories on ${timestamp()}"
      content = length(step.query.list_show_hn_stories.rows) > 0 ? "Top ${param.hn_story_count} Show HN stories:\n\n${join("", [for story in step.query.list_show_hn_stories.rows : format("%v\n%v score by %v\n%v}\n%v\n\n", story.title, story.score, story.by, story.url, story.text)])}" : "No stories available."
    }
  }

  output "send_mail_check" {
    value = !is_error(step.pipeline.send_mail) ? "Email sent to ${param.to}" : "Error sending email: ${error_message(step.pipeline.send_mail)}"
  }
}
