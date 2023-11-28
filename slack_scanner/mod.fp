mod "slack_scanner" {
  title       = "Slack Scanner"
  description = "Scan secrets and sensitive information on Slack."

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.0.1-rc.2"
      args = {
        token = var.slack_token
      }
    }
  }
}
