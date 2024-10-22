mod "send_slack_message_using_cron" {
  title         = "Send Slack Message Using Cron"
  description   = "Send a message to a Slack channel every minute using cron."
  documentation = file("./README.md")
  categories    = ["messaging", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "^1"
    }
  }
}
