mod "correlate_data_across_jira" {
  title       = "Correlate data across Jira"
  description = "Search for Jira issues, update issue if found, create a jira issue if not found."

  require {
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "*"
      args = {
        api_base_url = var.api_base_url
        token        = var.token
        user_email   = var.user_email
        project_key  = var.project_key
      }
    }
  }
}
