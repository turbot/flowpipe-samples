mod "notify_teams_gitlab_project_visibility" {
  title       = "Notify Teams on GitLab Project Visibility"
  description = "Notify a Teams channel on GitLab public projects, optionally update the visibility from public to private."
  categories  = ["software development"]

  require {
    mod "github.com/turbot/flowpipe-mod-gitlab" {
      version = "v0.0.1-rc.4"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.13"
      args = {
        team_id = var.team_id
      }
    }
  }
}
