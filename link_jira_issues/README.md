# Link Issues Across Jira

Search for related Jira issues using [Jira Query Language (JQL) query](https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/). If there are any issues found, update their descriptions with the related issue numbers, but if none are found, create a new issue with the query details.

## Usage

- Set your `JIRA_API_TOKEN`, `JIRA_URL`, `JIRA_USER` environment variables or configure your Jira credentials in `~/.flowpipe/config/jira.fpc`:
  ```hcl
  credential "jira" "jira_cred" {
    base_url    = "https://test.atlassian.net/"
    api_token   = "ATATT3........."
    username    = "abc@email.com"
  }
  ```
- Run the pipeline and specify `assignee_id`, `jql_query`, and `issue_type` e.g., `flowpipe pipeline run link_jira_issues --arg jql_query="summary~Test" --arg 'assignee_id=543256788888888' --arg 'issue_type=Bug'`
