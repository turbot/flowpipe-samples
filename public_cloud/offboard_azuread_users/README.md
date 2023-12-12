# Suspend, disable & enable users in Azure Active Directory

Suspend, disable and enable accounts in Azure Active Directory through Jira issues.

## Usage

- Add following required credentials to `flowpipe.pvars`
  - Jira token, API base url, user email and project key
  - Azure tenant ID, client secret, client ID and subscription ID
- Start your Flowpipe server
- Create the issue for Jira. This step is an independent pipeline to create issue e.g.
  ```
  flowpipe pipeline run create_user_update_issue  --arg user_id="test1@turbotad.onmicrosoft.com" --arg account_status="delete" --arg project_key="HSM"

  flowpipe pipeline run create_user_update_issue --arg user_id="test2@turbotad.onmicrosoft.com" --arg account_status="disable" --arg project_key="HSM"

  flowpipe pipeline run create_user_update_issue  --arg user_id="test2@turbotad.onmicrosoft.com" --arg account_status="enable" --arg project_key="HSM"
  ```
- When any issue is created in Jira, `scheduled_user_enable_action` scans the list of issues
  - Checks for issue summary for the action to be taken such as `Delete`, `Disable` and `Enable`
  - Checks the issues status as `Approval Done`
  - Triggers respective Azure pipelines

**Note:**
- Jira provides multiple project template to manage workflow within Jira project. This example uses `HSM: Default ESM workflow for Jira Service Management`, the issue status validation in the pipeline is based on the status name provided by this template.
- The approval process is done manually in Jira

