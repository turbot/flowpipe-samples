trigger "schedule" "list_iam_user_groups_associations" {
  description = "Runs daily at 9 AM UTC, this trigger scans for IAM users in multiple groups and creates/updates corresponding GitHub issues."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.aws_iam_user_group_membership
}

pipeline "aws_iam_user_group_membership" {
  title       = "Check AWS IAM User Group Membership"
  description = "Tracks IAM users in multiple groups and manages related GitHub issues. It creates a new issue for each user found in more than one group and updates existing issues if needed."

  param "github_token" {
    type    = string
    default = var.github_token
  }

  param "repository_owner" {
    type    = string
    default = local.repository_owner
  }

  param "repository_name" {
    type    = string
    default = local.repository_name
  }

  # Get the list of AWS IAM Users
  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
    args = {
      region            = var.aws_region
      access_key_id     = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
    }

    # When there are zero IAM users, exit the pipeline.
    throw {
      if      = result.output.stdout.Users == null
      message = "There are no IAM Users in the account. Exiting the pipeline."
    }
  }

  # Get the list of AWS IAM Groups for each user
  step "pipeline" "list_groups_assigned_to_user" {
    for_each = { for user in step.pipeline.list_iam_users.output.stdout.Users : user.UserName => user.UserName }
    pipeline = aws.pipeline.list_iam_groups_for_user
    args = {
      region            = var.aws_region
      access_key_id     = var.aws_access_key_id
      secret_access_key = var.aws_secret_access_key
      user_name         = each.value
    }
  }

  # If users is attached with more than one group, then search Github if an issue already exists. 
  # If a GitHub issue is already in place, add a comment; otherwise, create a new issue in the following steps.
  step "pipeline" "github_search_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.stdout }
    pipeline = github.pipeline.search_issues
    args = {
      access_token     = param.github_token
      repository_owner = local.repository_owner
      repository_name  = local.repository_name
      search_value     = "[AWS IAM User in Groups]: User '${each.key}' state:open"
    }
  }

  # If a GitHub issue in found in the above step for a particular user, add a comment to it.
  step "pipeline" "github_comment_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.stdout.Groups }
    if       = try(length(each.value), 1) > 1 && step.pipeline.github_search_issue[each.key].output.issues != null
    pipeline = github.pipeline.create_issue_comment
    args = {
      access_token     = param.github_token
      repository_owner = local.repository_owner
      repository_name  = local.repository_name
      issue_number     = step.pipeline.github_search_issue[each.key].output.issues[0].number
      issue_comment    = "Date: ${timestamp()}\nThe IAM groups assigned to user '${each.key}' are: ${join(", ", each.value[*].GroupName)}."
    }
  }

  # If a GitHub issue in found for a particular user, but user does not have multiple groups assigned anymore, close the issue.
  step "pipeline" "github_close_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.stdout.Groups }
    if       = try((length(each.value)), 1) <= 1 && step.pipeline.github_search_issue[each.key].output.issues != null
    pipeline = github.pipeline.close_issue
    args = {
      token            = param.github_token
      repository_owner = local.repository_owner
      repository_name  = local.repository_name
      issue_number     = step.pipeline.github_search_issue[each.key].output.issues[0].number
      state_reason     = "COMPLETED"
    }
  }

  # If a GitHub issue is not found in the github_search_issue step for a particular user, create one.
  step "pipeline" "github_create_issue" {
    for_each = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.stdout.Groups }
    if       = try(length(each.value), 1) > 1 && step.pipeline.github_search_issue[each.key].output.issues == null
    pipeline = github.pipeline.create_issue
    args = {
      access_token     = param.github_token
      repository_owner = local.repository_owner
      repository_name  = local.repository_name
      issue_title      = "[AWS IAM User in Groups]: User '${each.key}' is assigned with ${length(each.value)} IAM groups."
      issue_body       = "The IAM groups assigned to user '${each.key}' are: ${join(", ", each.value[*].GroupName)}."
    }
  }

  # output "iam_users" {
  #   description = "List of all AWS IAM Users."
  #   value       = step.pipeline.list_iam_users.output.stdout
  # }

  # output "iam_users_group_membership" {
  #   description = "List of all AWS IAM Groups for each user."
  #   value       = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.stdout }
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
