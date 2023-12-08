mod "send_slack_message" {
  title       = "Send Slack Message"
  description = "Send a message to a Slack channel."
  categories  = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.0.1-rc.6"
    }
  }
}
