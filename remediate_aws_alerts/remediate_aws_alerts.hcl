pipeline "remediate_aws_alerts" {

  param "issue_type" {
    type        = string
    description = "Issue type."
    default     = "Task"
  }

  param "api_base_url" {
    type        = string
    description = "Jira API base URL."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "Jira API token."
    default     = var.token
  }

  param "user_email" {
    type        = string
    description = "Jira user email."
    default     = var.user_email
  }

  param "project_key" {
    type        = string
    description = "Jira project key."
    default     = var.project_key
  }

  param "detector_id" {
    type        = string
    description = "The ID of the GuardDuty detector."
    default     = "34c5e9cdb5672958e2d67b9e24c0de22"
  }

  step "pipeline" "list_guardduty_findings" {
    pipeline = aws.pipeline.list_guardduty_findings
    args = {
      region            = var.region
      access_key_id     = var.access_key_id
      secret_access_key = var.secret_access_key
      detector_id       = param.detector_id
    }
  }

  step "pipeline" "get_guardduty_finding" {
    depends_on = [step.pipeline.list_guardduty_findings]
    pipeline   = aws.pipeline.get_guardduty_finding
    args = {
      region            = var.region
      access_key_id     = var.access_key_id
      secret_access_key = var.secret_access_key
      detector_id       = param.detector_id
      finding_id        = step.pipeline.list_guardduty_findings.output.stdout.FindingIds
    }
  }

  step "pipeline" "create_block_s3_public_access_issue" {
    depends_on = [step.pipeline.get_guardduty_finding]
    for_each = step.pipeline.get_guardduty_finding.output.stdout != null ? { for each_finding in step.pipeline.get_guardduty_finding.output.stdout.Findings : each_finding.Id => each_finding if strcontains(each_finding.Description, "Amazon S3 Block Public Access was disabled for S3 bucket")} : tomap({})
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Block ${each.value.Resource.S3BucketDetails[0].Name} S3 bucket public access."
      issue_type   = param.issue_type
    }
  }

  // step "pipeline" "create_set_new_security_group_issue" {
  //   pipeline = jira.pipeline.create_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     project_key  = param.project_key
  //     summary      = "Update i-0834b6dc568c4d381 with a new security group."
  //     issue_type   = param.issue_type
  //   }
  // }

  // step "pipeline" "create_dissociate_iam_instance_profile_issue" {
  //   pipeline = jira.pipeline.create_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     project_key  = param.project_key
  //     summary      = "Dissociate i-0834b6dc568c4d381 IAM instance profile from."
  //     issue_type   = param.issue_type
  //   }
  // }

  output "block_s3_public_access_issue" {
    value = step.pipeline.create_block_s3_public_access_issue
  }

  // output "set_new_security_group_issue" {
  //   value = step.pipeline.create_set_new_security_group_issue
  // }

  // output "dissociate_iam_instance_profile_issue" {
  //   value = step.pipeline.create_dissociate_iam_instance_profile_issue
  // }
}