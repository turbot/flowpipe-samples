mod "send_slack_message_using_cron" {
  title       = "Send Slack Message Using Cron"
  description = "Send a message to a Slack channel every minute using cron."
  categories  = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.0.1-rc.8"
    }
  }
}
