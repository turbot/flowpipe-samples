trigger "schedule" "scheduled_enable_entra_id_user" {
  description = "Scan Jira Issues to enable Entra ID User."

  # Run every 5 min
  schedule = "*/5 * * * *"
  pipeline = pipeline.enable_entra_id_user
}

pipeline "enable_entra_id_user" {
  title       = "Enable Entra ID User"
  description = "Enable user from Entra ID based on approval status."

  param "azure_cred" {
    type        = string
    description = "Name for Azure credentials to use. If not provided, the default credentials will be used."
    default     = var.azure_cred
  }

  param "jira_cred" {
    type        = string
    description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
    default     = var.jira_cred
  }

  param "project_key" {
    type        = string
    description = "The key identifying the project."
    default     = var.project_key
  }

  step "pipeline" "list_issues" {
    pipeline = jira.pipeline.list_issues
    args = {
      cred        = param.jira_cred
      project_key = param.project_key
    }
  }

  step "pipeline" "enable_entra_id_user" {
    depends_on = [step.pipeline.list_issues]
    for_each   = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Enable") && strcontains(each_issue.fields.status.name, "Done") } : tomap({})

    pipeline = entra.pipeline.update_user
    args = {
      cred            = param.azure_cred
      user_id         = split(" ", each.value.fields.summary)[1]
      account_enabled = split(" ", lower(each.value.fields.summary))[0] == "enable" ? "true" : "true"
    }
  }
}
