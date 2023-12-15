mod "send_slack_message" {
  title         = "Send Slack Message"
  description   = "Send a message to a Slack channel."
  documentation = file("./README.md")
  categories    = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.1.0"
    }
  }
}
