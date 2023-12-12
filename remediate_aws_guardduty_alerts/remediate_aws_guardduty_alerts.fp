trigger "http" "remediate_aws_guardduty_alerts" {
  title       = "GuardDuty Findings Webhook Events"
  description = "Webhook for Guard Duty Findings events."

  pipeline = pipeline.remediate_aws_guardduty_alerts
  args = {
    alert = jsondecode(self.request_body).Message
  }
}

pipeline "remediate_aws_guardduty_alerts" {
  title       = "Remediate AWS Guard Duty Alerts"
  description = "Automate AWS SNS notifications from Guard Duty Findings triggering Jira issue creation, execute actions in AWS for identified issues, and update issue state to done upon resolution."

  tags = {
    type = "featured"
  }

  param "jira_cred" {
    type        = string
    description = "Jira credentials."
    default     = var.jira_cred
  }

  param "issue_type" {
    type        = string
    description = "Jira issue type."
    default     = var.issue_type
  }

  param "alert" {
    type = any
  }

  param "jira_project_key" {
    type        = string
    description = "Jira project key."
    default     = var.jira_project_key
  }

  step "pipeline" "create_block_s3_public_access_issue" {
    if       = jsondecode(param.alert).detail.type == "Policy:S3/BucketBlockPublicAccessDisabled"
    pipeline = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      project_key = param.jira_project_key
      summary     = "Block ${jsondecode(param.alert).detail.resource.s3BucketDetails[0].name} S3 bucket public access."
      issue_type  = param.issue_type
    }
  }

  step "pipeline" "block_s3_public_access" {
    if         = jsondecode(param.alert).detail.type == "Policy:S3/BucketBlockPublicAccessDisabled"
    depends_on = [step.pipeline.create_block_s3_public_access_issue]
    pipeline   = pipeline.block_s3_public_access
    args = {
      bucket   = jsondecode(param.alert).detail.resource.s3BucketDetails[0].name
      issue_id = step.pipeline.create_block_s3_public_access_issue.output.issue.id
    }
  }

  step "pipeline" "create_disassociate_iam_instance_profile_issue" {
    if       = jsondecode(param.alert).detail.type == "UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.InsideAWS"
    pipeline = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      project_key = param.jira_project_key
      summary     = "Disasscociate ${jsondecode(param.alert).detail.resource.instanceDetails.instanceId} IAM role."
      issue_type  = param.issue_type
    }
  }

  step "pipeline" "disassociate_iam_instance_profile_actions" {
    if         = jsondecode(param.alert).detail.type == "UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.InsideAWS"
    depends_on = [step.pipeline.create_disassociate_iam_instance_profile_issue]
    pipeline   = pipeline.disassociate_iam_instance_profile_actions
    args = {
      instance_id = jsondecode(param.alert).detail.resource.instanceDetails.instanceId
      issue_id    = step.pipeline.create_disassociate_iam_instance_profile_issue.output.issue.id
    }
  }

  output "block_s3_public_access_issue" {
    value = jsondecode(param.alert).detail.type == "Policy:S3/BucketBlockPublicAccessDisabled"? !is_error(step.pipeline.block_s3_public_access) ? "Blocked public access for bucket ${jsondecode(param.alert).detail.resource.s3BucketDetails[0].name}, added an issue comment and updated issue status to done." : "Failed!!" : "No publicly accessible S3 bucket found."
  }

  output "disassociate_iam_instance_profile_issue" {
    value = jsondecode(param.alert).detail.type == "UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.InsideAWS"? !is_error(step.pipeline.disassociate_iam_instance_profile_actions) ? "Disassociated IAM role for instance ${jsondecode(param.alert).detail.resource.instanceDetails.instanceId}, added an issue comment and updated issue status to done." : "Failed!!" : "No unauthorized IAM role associated with ec2 instance found."
  }
}