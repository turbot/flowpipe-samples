//  Schedule Trigger
trigger "schedule" "scheduled_user_delete_action" {
  description = "A cron that checks xxxxx."
  schedule    = "* * * * *"
  // schedule    = "*/5 * * * *" // Run every 5 min
  pipeline    = pipeline.user_delete_action
}

pipeline "user_delete_action" {
  title       = "Delete Azure AD user"
  description = "Delete user from Azure AD based on approval status."

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

  // param "user_id" {
  //   type = string
  // }

  step "pipeline" "list_issues" {
    pipeline = jira.pipeline.list_issues
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
    }
  }


  step "pipeline" "ad_user_account_status" {
    depends_on = [step.pipeline.list_issues]

    // This below condition works with null check
    for_each = step.pipeline.list_issues.output.issue.issues != null ? { for each_issue in step.pipeline.list_issues.output.issue.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Delete") && each_issue.fields.status.name == "Approval Done" } : tomap({})


    pipeline = azure.pipeline.delete_ad_user
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      user_id         = split(" ", each.value.fields.summary)[1]
    }

  }

  // output "list_issues" {
  //   description = "List issues."
  //   value       = step.pipeline.list_issues
  // }

  output "account_status" {
    description = "List issues."
    value       = step.pipeline.ad_user_account_status
  }

}