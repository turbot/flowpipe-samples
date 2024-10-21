mod "send_slack_message_using_cron" {
  title         = "Send Slack Message Using Cron"
  description   = "Send a message to a Slack channel every minute using cron."
  documentation = file("./README.md")
  categories    = ["messaging", "sample"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.3.0-rc.2"
    }
  }
}
