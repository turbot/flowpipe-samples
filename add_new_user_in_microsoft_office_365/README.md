# Add New User in Microsoft Office 365

Add a new user in Microsoft Office 365.

## Usage

- Add your Teams Access Token, Team Id, JIRA Token, JIRA User Email, JIRA API Base URL and JIRA Project Key to `flowpipe.fpvars`
- Run the pipeline and specify `license_sku_ids`,`message`,`mail_nickname`,`account_enabled`,`user_principal_name`,`display_name` and `password`, e.g., `flowpipe pipeline run add_new_user_in_microsoft_office_365 --arg 'license_sku_ids=["944a8e14-7a6f-48c6-8805-6e93612f6c2"]' --arg 'message="Welcome to the team"' --arg 'mail_nickname="testFlowpipe"' --arg 'account_enabled=true' --arg 'user_principal_name=someuser@contoso.com' --arg 'display_name="test flowpipe"' --arg 'password="test@123"'`
