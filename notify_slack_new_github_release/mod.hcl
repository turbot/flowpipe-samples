mod "notify_slack_new_github_release" {
  title       = "Notify Slack for New GitHub Releases"
  description = "Notify a Slack channel when a new GitHub release is created."

  // TODO: Re-enable once mod install works
  /*
  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "*"
      args = {
        token                = var.github_token
        repository_full_name = var.github_repository_full_name
      }
    }

    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "*"
      args = {
        token   = var.slack_token
        channel = var.slack_channel
      }
    }
  }
  */
}
