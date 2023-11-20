# Correlate Data Across Jira

This pipeline is responsible for searching Jira issues. If any issues are found, it updates their description, summary, priority, and assignee. In case no issues are found, the pipeline creates a new one.

## Usage

- Add your Jira API token, user email-id, API base URL and project key to `flowpipe.pvars`
- Start your Flowpipe server
- Run the pipeline and specify `assignee_id`, `jql_query`, and `issue_type` e.g., `flowpipe pipeline run correlate_data_across_jira --pipeline-arg jql_query="project = HSP" --pipeline-arg assignee_id="543256788888888" --pipeline-arg issue_type="Bug"`
