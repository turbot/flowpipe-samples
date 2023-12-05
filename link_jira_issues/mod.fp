mod "link_jira_issues" {
  title       = "Link Issues Across Jira"
  description = "Search for related Jira issues using Jira Query Language (JQL) query. If there are any issues found, update their descriptions with the related issue numbers, but if none are found, create a new issue with the query details."

  require {
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.4"
      args = {
        api_base_url = var.jira_api_base_url
        token        = var.jira_token
        user_email   = var.jira_user_email
        project_key  = var.jira_project_key
      }
    }
  }
}
