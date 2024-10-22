# Link Issues Across Jira

Search for related Jira issues using [Jira Query Language (JQL) query](https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/). If there are any issues found, update their descriptions with the related issue numbers, but if none are found, create a new issue with the query details.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd productivity/link_jira_issues
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:


- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
connection "jira" "jira_conn" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3........."
  username    = "abc@email.com"
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `jira_project_key`, `jira_jql_query`, and `issue_type` pipeline arguments:

```sh
flowpipe pipeline run link_jira_issues --arg jira_jql_query="summary~Test" --arg 'jira_project_key=QWR' --arg 'jira_issue_type=Bug'
```
