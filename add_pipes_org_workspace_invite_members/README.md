# Invite members to join organization by email, create pipes workspace, add members to workspace

- Send email invitation to users to join as member in the organization.
- Create workspace in the organization and add members with role in the workspace.

## Usage

- Add following required credentials to `flowpipe.pvars`

  - Pipes API token to access the services. Find more info to generate access token [here].(https://turbot.com/pipes/docs/da-settings#tokens)

- Start your Flowpipe server
  - Send email invitation to users to join as member in the organization. e.g.

    ```
    flowpipe pipeline run invite_org_members_by_email --arg org_handle="<YourOrgName>" --arg member_email='["member1@gmail.com", "member1@gmail.com"]'

    ```

  - Create workspace in the organization and add members with role in the workspace.

    ```
    flowpipe pipeline run add_pipes_org_workspace_and_members --arg org_handle="<YourOrgName>" --arg workspace_handle="<WorkspaceName>"

    ```