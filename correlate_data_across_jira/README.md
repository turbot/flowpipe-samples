# Correlate Data Across Jira

Search for Jira issues, update the issue if found, and create a new issue if not found.

## Usage

- Add your Jira API token, user email-id, API base URL and project key to `flowpipe.pvars`
- Start your Flowpipe server
- Run the pipeline and specify `assignee_id`, `jql_query`, and `issue_type` e.g., `flowpipe pipeline run correlate_data_across_jira --pipeline-arg jql_query="project = HSP" --pipeline-arg assignee_id="543256788888888" --pipeline-arg issue_type="Bug"`
