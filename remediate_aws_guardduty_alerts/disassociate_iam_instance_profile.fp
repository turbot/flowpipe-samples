pipeline "disassociate_iam_instance_profile_actions" {

  param "jira_token" {
    type        = string
    description = "Jira API token."
    default = var.jira_token
  }

  param "jira_user_email" {
    type        = string
    description = "Jira user email."
    default     = var.jira_user_email
  }

  param "jira_api_base_url" {
    type        = string
    description = "API base URL."
    default     = var.jira_api_base_url
  }

  param "issue_id" {
    type        = string
    description = "Jira issue id."
  }

  param "aws_region" {
    type        = string
    description = "AWS region."
    default     = var.aws_region
  }

  param "aws_access_key_id" {
    type        = string
    description = "AWS access key id."
    default     = var.aws_access_key_id
  }

  param "aws_secret_access_key" {
    type        = string
    description = "AWS secret access key."
    default     = var.aws_secret_access_key
  }

  param "instance_id" {
    type        = string
    description = "AWS instance id."
  }

  step "pipeline" "describe_iam_instance_profile_associations" {
    pipeline = aws.pipeline.describe_iam_instance_profile_associations
    args = {
      region            = param.aws_region
      access_key_id     = param.aws_access_key_id
      secret_access_key = param.aws_secret_access_key
      instance_id       = param.instance_id
    }
  }

  step "pipeline" "disassociate_iam_instance_profile" {
    depends_on = [step.pipeline.describe_iam_instance_profile_associations]
    for_each   = values(step.pipeline.describe_iam_instance_profile_associations)[0].stdout.IamInstanceProfileAssociations != null ? { for each_association in values(step.pipeline.describe_iam_instance_profile_associations)[0].stdout.IamInstanceProfileAssociations : each_association.InstanceId => each_association.AssociationId } : tomap({})
    pipeline   = aws.pipeline.disassociate_iam_instance_profile
    args = {
      region            = param.aws_region
      access_key_id     = param.aws_access_key_id
      secret_access_key = param.aws_secret_access_key
      association_id    = each.value
      instance_id       = each.key
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.disassociate_iam_instance_profile]
    pipeline   = jira.pipeline.add_comment
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      issue_id     = param.issue_id
      comment_text = "Disassociated IAM Instance Profile from ${param.instance_id}."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      issue_key    = param.issue_id
    }
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.pipeline.get_issue_transitions]
    pipeline   = jira.pipeline.transition_issue
    args = {
      api_base_url  = param.jira_api_base_url
      token         = param.jira_token
      user_email    = param.jira_user_email
      issue_id      = param.issue_id
      transition_id = tonumber([for transition in step.pipeline.get_issue_transitions.output.transitions : transition.id if transition.name == "Done"][0])
    }
  }

}