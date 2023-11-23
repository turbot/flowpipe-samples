pipeline "disassociate_iam_instance_profile_actions" {

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

  param "issue_id" {
    type        = string
    description = "Jira issue id."
  }

  param "region" {
    type        = string
    description = "AWS region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "AWS access key id."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "AWS secret access key."
    default     = var.secret_access_key
  }

  param "instance_id" {
    type        = string
    description = "AWS instance id."
  }

  step "pipeline" "describe_iam_instance_profile_associations" {
    pipeline = aws.pipeline.describe_iam_instance_profile_associations
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      instance_id       = param.instance_id
    }
  }

  step "pipeline" "disassociate_iam_instance_profile" {
    depends_on = [step.pipeline.describe_iam_instance_profile_associations]
    for_each   = values(step.pipeline.describe_iam_instance_profile_associations)[0].stdout.IamInstanceProfileAssociations != null ? { for each_association in values(step.pipeline.describe_iam_instance_profile_associations)[0].stdout.IamInstanceProfileAssociations : each_association.InstanceId => each_association.AssociationId } : tomap({})
    pipeline   = aws.pipeline.disassociate_iam_instance_profile
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      association_id    = each.value
      instance_id       = each.key
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.disassociate_iam_instance_profile]
    pipeline   = jira.pipeline.add_comment
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_id     = param.issue_id
      comment_text = "Disassociated IAM Instance Profile from ${param.instance_id}."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_key    = param.issue_id
    }
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.pipeline.get_issue_transitions]
    pipeline   = jira.pipeline.transition_issue
    args = {
      api_base_url  = param.api_base_url
      token         = param.token
      user_email    = param.user_email
      issue_id      = param.issue_id
      transition_id = tonumber([for transition in step.pipeline.get_issue_transitions.output.transitions : transition.id if transition.name == "Done"][0])
    }
  }

}