pipeline "notify_suspend_disable_azuread_account" {
  title       = "AzureAD user off-boarding"
  description = "Jira tasks for user off-boarding."

  //Azure Setup

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive  = true
  }

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
    # TODO: Add once supported
    #sensitive  = true
    default = var.subscription_id
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive  = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive  = true
  }

  param "user_id" {
    type        = string
    description = "The AzureAD user object ID or principal name."
  }

  //Jira Setup

  param "token" {
    type        = string
    description = "API access token"
    # TODO: Add once supported
    # sensitive  = true
    default = var.token
  }

  param "user_email" {
    type        = string
    description = "Email-id of the user."
    default     = var.user_email
  }

  param "api_base_url" {
    type        = string
    description = "API base URL."
    default     = var.api_base_url
  }

  param "project_key" {
    type        = string
    description = "The key identifying the project."
    default     = var.project_key
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
    default     = "Task"
  }

  // param "summary" {
  //   type        = string
  //   description = "Issue summary."
  // }

  // param "description" {
  //   type        = string
  //   description = "Issue description."
  // }

  step "pipeline" "get_ad_user" {
    pipeline = azure.pipeline.get_ad_user
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      user_id         = param.user_id
    }
  }

  // step "echo" "user" {
  //   text = try(step.pipeline.get_ad_user, "user error aya")
  // }

  // step "echo" "principal" {
  //   text = try(step.pipeline.get_ad_user.output.user.userPrincipalName, "principal error aya")
  // }

  step "pipeline" "create_issue" {
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key

      // summary      = "Off-boarding user ${step.pipeline.get_ad_user.output.user}"
      // summary = step.pipeline.get_ad_user.output.user.
      summary = "Off-boarding user ${param.user_id}" // Not dynamic
      // description = "User Details ${step.pipeline.get_ad_user.output.user}"
      // description = step.pipeline.get_ad_user.output.user
      description = "User Details"

      issue_type = param.issue_type
    }
  }

  output "issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_issue
  }

  output "user" {
    description = "User info."
    value       = step.pipeline.get_ad_user
  }

}
