# Schedule Trigger
trigger "schedule" "scheduled_user_enable_action" {
  description = "A cron schedule that checks specific time or interval."
  # schedule    = "* * * * *" // Run every 1 min
  # Run every 5 min
  schedule = "*/5 * * * *"
  pipeline = pipeline.user_enable_action
}

pipeline "user_enable_action" {
  title       = "Enable Azure AD user"
  description = "Enable user from Azure AD based on approval status."

  # Azure Setup
  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
  }

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
    default     = var.subscription_id
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
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


  step "pipeline" "list_issues" {
    pipeline = jira.pipeline.list_issues
    args = {
      project_key = param.project_key
    }
  }

  step "pipeline" "ad_user_account_status" {
    depends_on = [step.pipeline.list_issues]
    for_each = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Enable") && each_issue.fields.status.name == "Approval Done" } : tomap({})

    pipeline = azure.pipeline.update_user_status
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      user_id         = split(" ", each.value.fields.summary)[1]
      account_enabled = split(" ", each.value.fields.summary)[0] == "Enable" ? "true" : "true"
    }

  }

}
