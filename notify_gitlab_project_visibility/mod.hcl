mod "notify_gitlab_project_visibility" {
  title       = "Notify GitLab Project Visibility Changes"
  description = "Notify a Slack channel when a GitLab's project visibility is changed."

  require {
    mod "github.com/turbot/flowpipe-mod-gitlab" {
      version = "v0.0.1-rc-3"
      args = {
        access_token = var.gitlab_access_token
      }
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.0.1"
      args = {
        token   = var.slack_token
        channel = var.slack_channel
      }
    }
  }
}
