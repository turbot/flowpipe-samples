mod "link_jira_issues" {
  title         = "Link Issues Across Jira"
  description   = "Search for related Jira issues using Jira Query Language (JQL) query. If there are any issues found, update their descriptions with the related issue numbers, but if none are found, create a new issue with the query details."
  documentation = file("./README.md")
  categories    = ["productivity"]

  require {
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "1.0.0-rc.1"
    }
  }
}
