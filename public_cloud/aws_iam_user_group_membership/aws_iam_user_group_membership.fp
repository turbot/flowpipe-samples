trigger "schedule" "aws_iam_user_group_membership" {
  title       = "Schedule Check AWS IAM User Group Membership"
  description = "Automate GitHub issue management for AWS IAM users with multiple group memberships at 9 AM UTC on weekdays."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.aws_iam_user_group_membership
}

pipeline "aws_iam_user_group_membership" {
  title       = "Check AWS IAM User Group Membership"
  description = "Monitors IAM users across various groups and oversees associated GitHub issues. It generates new issues for users belonging to multiple groups and updates existing issues as necessary."

  tags = {
    type = "featured"
  }

  param "github_cred" {
    type        = string
    description = "Name for GitHub credentials to use. If not provided, the default credentials will be used."
    default     = var.github_cred
  }

  param "aws_cred" {
    type        = string
    description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
    default     = var.aws_cred
  }

  param "github_repository_owner" {
    type        = string
    description = "The organization or user name."
  }

  param "github_repository_name" {
    type        = string
    description = "The name of the repository."
  }

  # Get the list of AWS IAM Users
  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
    args = {
      cred = param.aws_cred
    }
  }

  # Get the list of AWS IAM Groups for each user
  step "pipeline" "list_groups_assigned_to_user" {
    for_each = { for user in step.pipeline.list_iam_users.output.users : user.UserName => user.UserName }
    pipeline = aws.pipeline.list_iam_groups_for_user
    args = {
      cred      = param.aws_cred
      user_name = each.value
    }
  }

  # If users is attached with more than one group, then search Github if an issue already exists. 
  # If a GitHub issue is already in place, add a comment; otherwise, create a new issue in the following steps.
  step "pipeline" "github_search_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output }
    pipeline = github.pipeline.search_issues
    args = {
      cred             = param.github_cred
      repository_owner = param.github_repository_owner
      repository_name  = param.github_repository_name
      search_value     = "[AWS IAM User in Groups]: User '${each.key}' state:open"
    }
  }

  # If a GitHub issue in found in the above step for a particular user, add a comment to it.
  step "pipeline" "github_comment_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.groups }
    if       = length(each.value) > 1 && length(step.pipeline.github_search_issue[each.key].output.issues) > 0
    pipeline = github.pipeline.create_issue_comment
    args = {
      cred             = param.github_cred
      repository_owner = param.github_repository_owner
      repository_name  = param.github_repository_name
      issue_number     = step.pipeline.github_search_issue[each.key].output.issues[0].number
      issue_comment    = "Date: ${timestamp()}\nThe IAM groups assigned to user '${each.key}' are: ${join(", ", each.value[*].GroupName)}."
    }
  }

  # If a GitHub issue in found for a particular user, but user does not have multiple groups assigned anymore, close the issue.
  step "pipeline" "github_close_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.groups }
    if       = length(each.value) <= 1 && length(step.pipeline.github_search_issue[each.key].output.issues) > 0
    pipeline = github.pipeline.close_issue
    args = {
      cred             = param.github_cred
      repository_owner = param.github_repository_owner
      repository_name  = param.github_repository_name
      issue_number     = step.pipeline.github_search_issue[each.key].output.issues[0].number
      state_reason     = "COMPLETED"
    }
  }

  # If a GitHub issue is not found in the github_search_issue step for a particular user, create one.
  step "pipeline" "github_create_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.groups }
    if       = length(each.value) > 1 && length(step.pipeline.github_search_issue[each.key].output.issues) == 0
    pipeline = github.pipeline.create_issue
    args = {
      cred             = param.github_cred
      repository_owner = param.github_repository_owner
      repository_name  = param.github_repository_name
      issue_title      = "[AWS IAM User in Groups]: User '${each.key}' is assigned with ${length(each.value)} IAM groups."
      issue_body       = "The IAM groups assigned to user '${each.key}' are: ${join(", ", each.value[*].GroupName)}."
    }
  }

  # output "iam_users" {
  #   description = "List of all AWS IAM Users."
  #   value       = step.pipeline.list_iam_users.output.users
  # }

  # output "iam_users_group_membership" {
  #   description = "List of all AWS IAM Groups for each user."
  #   value       = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.groups }
  # }

  # output "github_search_issue" {
  #   description = "Search for list of GitHub issues for each user."
  #   value       = { for user, issues in step.pipeline.github_search_issue : user => try(issues.output, issues) }
  # }

  output "github_comment_issue" {
    description = "Existing GitHub issues commented for each user in multiple groups."
    value       = { for user, issues in step.pipeline.github_comment_issue : user => try(issues.output, issues) }
  }

  output "github_close_issue" {
    description = "GitHub issues closed for each user no longer in multiple groups."
    value       = { for user, issues in step.pipeline.github_close_issue : user => try(issues.output, issues) }
  }

  output "github_create_issue" {
    description = "GitHub issues created for each user in multiple groups."
    value       = { for user, issue in step.pipeline.github_create_issue : user => try(issue.output, issue) }
  }
}
