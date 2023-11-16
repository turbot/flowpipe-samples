trigger "schedule" "list_iam_user_groups_associations" {
  description = "A daily cron job at 9 AM UTC that checks for AWS IAM users with multiple group assignments, creates issues in Github."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.aws_iam_user_in_groups
}

pipeline "aws_iam_user_in_groups" {
  title       = "List AWS IAM User Group Associations"
  description = "List IAM Users associated with more than a Group. Create a GitHub issue for User if there isn't one already. If an issue is already present then update the same."

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

  output "iam_users" {
    value = step.pipeline.list_iam_users.output.stdout
  }

  output "iam_groups_for_users" {
    value = { for user, groups in step.pipeline.list_groups_assigned_to_user : user => groups.output.stdout }
  }

  output "github_search_issue" {
    value = { for user, issues in step.pipeline.github_search_issue : user => try(issues.output, issues) }
  }

  output "github_comment_issue" {
    value = { for user, issues in step.pipeline.github_comment_issue : user => try(issues.output, issues) }
  }

  output "github_create_issue" {
    value = { for user, issue in step.pipeline.github_create_issue : user => try(issue.output, issue) }
  }
}
