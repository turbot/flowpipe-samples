pipeline "disassociate_iam_instance_profile_actions" {

  param "jira_cred" {
    type        = string
    description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
    default     = var.jira_cred
  }

  param "aws_cred" {
    type        = string
    description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
    default     = var.aws_cred
  }

  param "jira_issue_id" {
    type        = string
    description = "Jira issue id."
  }

  param "aws_region" {
    type        = string
    description = "AWS region."
  }

  param "aws_instance_id" {
    type        = string
    description = "AWS instance id."
  }

  step "pipeline" "describe_iam_instance_profile_associations" {
    pipeline = aws.pipeline.describe_iam_instance_profile_associations
    args = {
      cred        = param.aws_cred
      region      = param.aws_region
      instance_id = param.aws_instance_id
    }
  }

  step "pipeline" "disassociate_iam_instance_profile" {
    depends_on = [step.pipeline.describe_iam_instance_profile_associations]
    for_each   = step.pipeline.describe_iam_instance_profile_associations.output.iam_instance_profile_associations != null ? { for each_association in step.pipeline.describe_iam_instance_profile_associations.output.iam_instance_profile_associations : each_association.InstanceId => each_association.AssociationId } : tomap({})
    pipeline   = aws.pipeline.disassociate_iam_instance_profile
    args = {
      cred           = param.aws_cred
      region         = param.aws_region
      association_id = each.value
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.disassociate_iam_instance_profile]
    pipeline   = jira.pipeline.add_comment
    args = {
      cred         = param.jira_cred
      issue_id     = param.jira_issue_id
      comment_text = "Disassociated IAM Instance Profile from ${param.aws_instance_id}."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      cred      = param.jira_cred
      issue_key = param.jira_issue_id
    }
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.pipeline.get_issue_transitions]
    pipeline   = jira.pipeline.transition_issue
    args = {
      cred          = param.jira_cred
      issue_id      = param.jira_issue_id
      transition_id = tonumber([for transition in step.pipeline.get_issue_transitions.output.transitions : transition.id if transition.name == "Done"][0])
    }
  }

}