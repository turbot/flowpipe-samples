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

  param "account_enabled" {
    type        = string
    description = "User account status."
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

  step "pipeline" "create_issue" {
    depends_on = [step.pipeline.get_ad_user]
    pipeline   = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Off-boarding user ${step.pipeline.get_ad_user.output.user.userPrincipalName}"
      description  = "User Details ${jsonencode(step.pipeline.get_ad_user.output.user)}"
      issue_type   = param.issue_type
    }
  }

  // We need to hold this pipeline execution till the  status is changed to DONE in JIRA??
  //Alternative
  step "sleep" "sleep" {
    depends_on = [step.pipeline.create_issue]
    duration   = "30s"
  }

  //Using Trigger
  // Schedule Trigger
  // trigger "schedule" "pipeline.get_issue_status" {
  //   description = "A cron that checks the status of the JIRA issue, if it is approved or not every MON at 9AM UTC."
  //   schedule    = "0 9 * * *"
  //   pipeline    = pipeline.get_issue_status
  // }

  // // Interval Trigger
  // trigger "interval" "pipeline.get_issue_status" {
  //   description = "A daily interval job that checks for unencrypted volumes and creates/update a GitHub Issue."
  //   schedule    = "daily"
  //   pipeline    = pipeline.get_issue_status
  // }

  step "pipeline" "get_issue_status" {
    depends_on = [step.sleep.sleep]
    pipeline   = jira.pipeline.get_issue_status
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_id     = step.pipeline.create_issue.output.issue.id
    }
  }

  // step "pipeline" "delete_ad_user" {
  //   depends_on = [step.pipeline.get_issue_status]
  //   if       = strcontains(step.pipeline.get_issue_status.output.status, "Approval Done") == true
  //   pipeline = azure.pipeline.delete_ad_user
  //   args = {
  //     tenant_id       = param.tenant_id
  //     client_secret   = param.client_secret
  //     client_id       = param.client_id
  //     subscription_id = param.subscription_id
  //     user_id         = param.user_id
  //   }

  // }

  step "pipeline" "ad_user_account_status" {
    depends_on = [step.pipeline.get_issue_status]
    if         = strcontains(step.pipeline.get_issue_status.output.status, "Approval Done") == true
    pipeline   = azure.pipeline.ad_user_account_status
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      user_id         = param.user_id
      account_enabled = param.account_enabled
    }

  }

  output "user" {
    description = "User info."
    value       = step.pipeline.get_ad_user
  }

  output "issue" {
    description = "Issue metadata."
    value       = step.pipeline.create_issue
  }

  output "issue_status" {
    description = "Issue info."
    value       = step.pipeline.get_issue_status.output.status
  }

  // output "delete_status" {
  //   description = "Delete info."
  //   value       = step.pipeline.delete_ad_user.output.stdout
  // }

}
