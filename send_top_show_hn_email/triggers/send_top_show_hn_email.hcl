trigger "schedule" "send_top_show_hn_email" {
  description = "Send an email every day at 12 PM UTC that shows Hacker News trending stories."
  schedule = "0 12 * * *"
  pipeline = pipeline.send_top_show_hn_email
}
