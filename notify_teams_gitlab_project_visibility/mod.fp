mod "notify_teams_gitlab_project_visibility" {
  title         = "Notify Teams on GitLab Project Visibility"
  description   = "Notify a Teams channel on GitLab public projects, optionally update the visibility from public to private."
  documentation = file("./README.md")
  categories    = ["software development"]

  require {
    mod "github.com/turbot/flowpipe-mod-gitlab" {
      version = "v0.0.1-rc.7"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.18"
    }
  }
}
