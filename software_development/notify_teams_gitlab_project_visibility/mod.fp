mod "notify_teams_gitlab_project_visibility" {
  title         = "Notify Teams on GitLab Project Visibility"
  description   = "Notify a Teams channel on GitLab public projects, optionally update the visibility from public to private."
  documentation = file("./README.md")
  categories    = ["software development"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-gitlab" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "^1"
    }
  }
}
