pipeline "add_new_user_in_microsoft_office_365" {
  title       = "Add New User in Microsoft Office 365"
  description = "Add a new user in Microsoft Office 365."

  tags = {
    recommended = "true"
  }

  param "jira_conn" {
    type        = connection.jira
    description = "Name of Jira connection to use. If not provided, the default Jira connection will be used."
    default     = connection.jira.default
  }

  param "jira_project_key" {
    type        = string
    description = "The key identifying the Jira project."
  }

  param "jira_issue_type" {
    type        = string
    description = "The issue type the Jira project."
  }

  param "teams_conn" {
    type        = connection.teams
    description = "Name of Teams connection to use. If not provided, the default Teams connection will be used."
    default     = connection.teams.default
  }

  param "teams_display_name" {
    type        = string
    description = "The name to display in the address book for the user."
  }

  param "teams_account_enabled" {
    type        = bool
    description = "If the account is enabled then true; otherwise, false."
  }

  param "teams_mail_nickname" {
    type        = string
    description = "The mail alias for the user."
  }

  param "teams_user_principal_name" {
    type        = string
    description = "The user principal name (someuser@contoso.com)."
  }

  param "teams_password" {
    type        = string
    description = "The password for the user."
  }

  param "teams_chat_type" {
    type        = string
    description = "Specifies the type of chat."
  }

  param "teams_message_content_type" {
    type        = string
    description = "The type of the content. Possible values are text and html."
  }

  param "teams_license_sku_ids" {
    type        = list(string)
    description = "The unique identifier for the available licenses."
  }

  param "teams_team_id" {
    type        = string
    description = "The unique identifier for the team."
  }

  param "teams_roles" {
    type        = list(string)
    description = "The roles for the user."
  }

  param "teams_message" {
    type        = string
    description = "The message to send."
  }

  # Create user
  step "pipeline" "create_user" {
    pipeline = teams.pipeline.create_user
    args = {
      conn                = param.teams_conn
      password            = param.teams_password
      user_principal_name = param.teams_user_principal_name
      mail_nickname       = param.teams_mail_nickname
      account_enabled     = param.teams_account_enabled
      display_name        = param.teams_display_name
    }
  }

  # Assign license to the user
  step "pipeline" "assign_licenses_to_user" {
    depends_on = [step.pipeline.create_user]
    pipeline   = teams.pipeline.assign_licenses_to_user
    args = {
      conn    = param.teams_conn
      sku_ids = param.teams_license_sku_ids
      user_id = param.teams_user_principal_name
    }
  }

  # Create JIRA issue
  step "pipeline" "create_issue" {
    depends_on = [step.pipeline.create_user]
    pipeline   = jira.pipeline.create_issue
    args = {
      conn        = param.jira_conn
      project_key = param.jira_project_key
      summary     = "Add a new user: ${step.pipeline.create_user.output.user.userPrincipalName}"
      description = jsonencode(step.pipeline.create_user.output.user)
      issue_type  = param.jira_issue_type
    }
  }

  # Add user to a team
  step "pipeline" "add_team_member" {
    depends_on = [step.pipeline.create_issue]
    pipeline   = teams.pipeline.add_team_member
    args = {
      conn    = param.teams_conn
      team_id = param.teams_team_id
      user_id = param.teams_user_principal_name
      roles   = param.teams_roles
    }
  }

  # Create chat with the user
  step "pipeline" "create_chat" {
    depends_on = [step.pipeline.add_team_member]
    pipeline   = teams.pipeline.create_chat
    args = {
      conn      = param.teams_conn
      chat_type = param.teams_chat_type
      user_ids  = ["${param.teams_user_principal_name}"]
    }
  }

  # Send chat message to the user
  step "pipeline" "send_chat_message" {
    depends_on = [step.pipeline.create_chat]
    pipeline   = teams.pipeline.send_chat_message
    args = {
      conn                 = param.teams_conn
      chat_id              = step.pipeline.create_chat.output.chat.id
      message              = param.teams_message
      message_content_type = param.teams_message_content_type
    }
  }
}
