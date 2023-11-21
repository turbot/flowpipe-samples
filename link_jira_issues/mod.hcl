mod "link_jira_issues" {
  title       = "Link Issues Across Jira"
  description = "Search for Jira issues, update description, summary, priority, and assignee in an issue if found, create a jira issue if not found."

  require {
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.4-rc.0"
      args = {
        api_base_url = var.api_base_url
        token        = var.token
        user_email   = var.user_email
        project_key  = var.project_key
      }
    }
  }
}
