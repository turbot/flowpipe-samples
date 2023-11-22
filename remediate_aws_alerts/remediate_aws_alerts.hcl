trigger "http" "remediate_aws_alerts" {
  title       = "Guard Duty Findings Webhook Events"
  description = "Webhook for Guard Duty Findings events."

  pipeline = pipeline.remediate_aws_alerts
  args = {
    alert = jsondecode(self.request_body).Message
  }
}

pipeline "remediate_aws_alerts" {

  param "issue_type" {
    type        = string
    description = "Issue type."
    default     = "Task"
  }

  param "alert" {
    type    = any
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

  step "pipeline" "create_block_s3_public_access_issue" {
    if       = jsondecode(param.alert).detail.type == "Policy:S3/BucketBlockPublicAccessDisabled"
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "Block ${jsondecode(param.alert).detail.resource.s3BucketDetails[0].name} S3 bucket public access."
      issue_type   = param.issue_type
    }
  }

  step "pipeline" "block_s3_public_access" {
    depends_on = [step.pipeline.create_block_s3_public_access_issue]
    pipeline   = pipeline.block_s3_public_access
    args = {
      bucket   = jsondecode(param.alert).detail.resource.s3BucketDetails[0].name
      issue_id = step.pipeline.create_block_s3_public_access_issue.output.issue.id
    }
  }

  // step "pipeline" "create_dissociate_iam_instance_profile_issue" {
  //   depends_on = [step.pipeline.get_guardduty_finding]
  //   for_each   = step.pipeline.get_guardduty_finding.output.stdout != null ? { for each_finding in step.pipeline.get_guardduty_finding.output.stdout.Findings : each_finding.Id => each_finding if strcontains(each_finding.Description, "Credentials created exclusively for an EC2 instance using instance role") } : tomap({})
  //   pipeline   = jira.pipeline.create_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     project_key  = param.project_key
  //     summary      = "Disasscociate ${each.value.Resource.InstanceDetails.InstanceId} IAM role."
  //     issue_type   = param.issue_type
  //   }
  // }

  // output "block_s3_public_access_issue" {
  //   value = step.pipeline.create_block_s3_public_access_issue
  // }

  // output "dissociate_iam_instance_profile_issue" {
  //   value = step.pipeline.create_dissociate_iam_instance_profile_issue
  // }
}