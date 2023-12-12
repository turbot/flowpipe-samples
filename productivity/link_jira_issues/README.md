# Link Issues Across Jira

Search for related Jira issues using [Jira Query Language (JQL) query](https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/). If there are any issues found, update their descriptions with the related issue numbers, but if none are found, create a new issue with the query details.

## Usage

- Add your Jira API token, user email, API base URL and project key to `flowpipe.pvars`
- Start your Flowpipe server run `flowpipe server`
- Run the pipeline and specify `assignee_id`, `jql_query`, and `issue_type` e.g., `flowpipe pipeline run link_jira_issues --arg jql_query="project = HSP" --arg assignee_id="543256788888888" --arg issue_type="Bug" --host http://localhost:7103`
