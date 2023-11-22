pipeline "add_new_user_in_microsoft_teams" {
  title       = "Add a new user in Microsoft Office 365"
  description = "Add a new user in Microsoft Office 365."

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

  # Asign license to the user
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
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Added a new user: ${step.pipeline.create_user.output.create_user.userPrincipalName}"
      description  = step.pipeline.create_user.output.create_user
      issue_type   = param.issue_type
    }
  }


}