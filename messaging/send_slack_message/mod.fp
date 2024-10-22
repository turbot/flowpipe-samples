mod "send_slack_message" {
  title         = "Send Slack Message"
  description   = "Send a message to a Slack channel."
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
