mod "send_slack_message" {
  title       = "Send Slack Message"
  description = "Send a message to a Slack channel."

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.0.1-rc.2"
      args = {
        token = var.slack_token
      }
    }
  }
}
