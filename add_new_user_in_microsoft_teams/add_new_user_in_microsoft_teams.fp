pipeline "add_new_user_in_microsoft_teams" {
  title       = "Add New User in Microsoft Teams"
  description = "Add a new user in Microsoft Teams."

  param "teams_access_token" {
    type        = string
    description = "The MS Team access token to use for the API request."
    default     = var.teams_access_token
  }

  param "display_name" {
    type        = string
    description = "The name to display in the address book for the user."
  }

  param "account_enabled" {
    type        = bool
    description = "If the account is enabled then true; otherwise, false."
  }

  param "mail_nickname" {
    type        = string
    description = "The mail alias for the user."
  }

  param "user_principal_name" {
    type        = string
    description = "The user principal name (someuser@contoso.com)."
  }

  param "password" {
    type        = string
    description = "The password for the user."
  }

  param "license_sku_ids" {
    type        = list(string)
    description = "The unique identifier for the available licenses."
  }

  param "jira_token" {
    type        = string
    description = "Jira API access token."
    default     = var.jira_token
  }

  param "jira_user_email" {
    type        = string
    description = "Email-id of the Jira user."
    default     = var.jira_user_email
  }

  param "jira_api_base_url" {
    type        = string
    description = "Jira API base URL."
    default     = var.jira_api_base_url
  }

  param "jira_project_key" {
    type        = string
    description = "The key identifying the Jira project."
    default     = var.jira_project_key
  }

  param "team_id" {
    type        = string
    description = "The unique identifier for the team."
    default     = var.team_id
  }

  param "roles" {
    type        = list(string)
    default     = ["member"] // or "owner" or other applicable roles
    description = "The roles for the user."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  # Create user
  step "pipeline" "create_user" {
    pipeline = teams.pipeline.create_user
    args = {
      access_token        = param.teams_access_token
      password            = param.password
      user_principal_name = param.user_principal_name
      mail_nickname       = param.mail_nickname
      account_enabled     = param.account_enabled
      display_name        = param.display_name
    }
  }

  # Assign license to the user
  step "pipeline" "assign_licenses_to_user" {
    depends_on = [step.pipeline.create_user]
    pipeline   = teams.pipeline.assign_licenses_to_user
    args = {
      access_token = param.teams_access_token
      sku_ids      = param.license_sku_ids
      user_id      = param.user_principal_name
    }
  }

  # Create JIRA issue
  step "pipeline" "create_issue" {
    depends_on = [step.pipeline.assign_licenses_to_user]
    pipeline   = jira.pipeline.create_issue
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      project_key  = param.jira_project_key
      summary      = "Add a new user: ${step.pipeline.create_user.output.create_user.userPrincipalName}"
      description  = jsonencode(step.pipeline.create_user.output.create_user)
      issue_type   = "New Feature"
    }
  }

  # Add user to a team
  step "pipeline" "add_team_member" {
    depends_on = [step.pipeline.create_issue]
    pipeline   = teams.pipeline.add_team_member
    args = {
      access_token = param.teams_access_token
      team_id      = param.team_id
      user_id      = param.user_principal_name
      roles        = param.roles
    }
  }

  # Create chat with the user
  step "pipeline" "create_chat" {
    depends_on = [step.pipeline.add_team_member]
    pipeline   = teams.pipeline.create_chat
    args = {
      access_token = param.teams_access_token
      chat_type    = "oneOnOne"
      user_ids     = ["${param.user_principal_name}"]
      roles        = param.roles
    }
  }

  # Send chat message to the user
  step "pipeline" "send_chat_message" {
    depends_on = [step.pipeline.create_chat]
    pipeline   = teams.pipeline.send_chat_message
    args = {
      access_token = param.teams_access_token
      chat_id      = step.pipeline.create_chat.output.chat.id
      message      = param.message
    }
  }
}