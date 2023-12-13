pipeline "add_new_user_in_microsoft_office_365" {
  title       = "Add New User in Microsoft Office 365"
  description = "Add a new user in Microsoft Office 365."

  tags = {
    type = "featured"
  }

  param "jira_cred" {
    type        = string
    description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "teams_cred" {
    type        = string
    description = "Name for Teams credentials to use. If not provided, the default credentials will be used."
    default     = "default"
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

  param "jira_project_key" {
    type        = string
    description = "The key identifying the Jira project."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier for the team."
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
      cred                = param.teams_cred
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
      cred    = param.teams_cred
      sku_ids = param.license_sku_ids
      user_id = param.user_principal_name
    }
  }

  # Create JIRA issue
  step "pipeline" "create_issue" {
    depends_on = [step.pipeline.assign_licenses_to_user]
    pipeline   = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      project_key = param.jira_project_key
      summary     = "Add a new user: ${step.pipeline.create_user.output.user.userPrincipalName}"
      description = jsonencode(step.pipeline.create_user.output.user)
      issue_type  = "New Feature"
    }
  }

  # Add user to a team
  step "pipeline" "add_team_member" {
    depends_on = [step.pipeline.create_issue]
    pipeline   = teams.pipeline.add_team_member
    args = {
      cred    = param.teams_cred
      team_id = param.team_id
      user_id = param.user_principal_name
      roles   = param.roles
    }
  }

  # Create chat with the user
  step "pipeline" "create_chat" {
    depends_on = [step.pipeline.add_team_member]
    pipeline   = teams.pipeline.create_chat
    args = {
      cred      = param.teams_cred
      chat_type = "oneOnOne"
      user_ids  = ["${param.user_principal_name}"]
    }
  }

  # Send chat message to the user
  step "pipeline" "send_chat_message" {
    depends_on = [step.pipeline.create_chat]
    pipeline   = teams.pipeline.send_chat_message
    args = {
      cred    = param.teams_cred
      chat_id = step.pipeline.create_chat.output.chat.id
      message = param.message
    }
  }
}
