mod "notify_slack_new_github_release" {
  title       = "Notify Slack for New GitHub Releases"
  description = "Notify a Slack channel when a new GitHub release is created."

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.0.1-rc.1"
      args = {
        token   = var.slack_token
        channel = var.slack_channel
      }
    }
  }
}
