mod "notify_teams_gitlab_project_visibility" {
  title       = "Notify Teams on GitLab Project Visibility"
  description = "Notify a Teams channel on GitLab public projects, optionally update the visibility from public to private."

  require {
    mod "github.com/turbot/flowpipe-mod-gitlab" {
      version = "v0.0.1-rc-3"
      args = {
        access_token = var.gitlab_access_token
      }
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.4"
      args = {
        access_token = var.teams_access_token
        team_id      = var.team_id
      }
    }
  }
}
