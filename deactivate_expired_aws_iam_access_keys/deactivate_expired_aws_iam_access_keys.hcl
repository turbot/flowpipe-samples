pipeline "deactivate_expired_aws_iam_access_keys" {
  title = "Deactivate expired AWS IAM access keys"
  description = "Deactivates expired AWS IAM access keys."

  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
  }

  output "iam_users" {
    description = "List of IAM users."
    value       = step.pipeline.list_iam_users.output.stdout
  }

  step "pipeline" "list_iam_access_keys" {
    for_each = step.pipeline.list_iam_users.output.stdout.Users
    pipeline = aws.pipeline.list_iam_access_keys
    args = {
      user_name = each.value.UserName
    }
  }

  step "pipeline" "update_iam_access_key_status" {
    for_each = step.pipeline.list_iam_access_keys
    # Run only if the access key is active and older than 90 days. (2160h = 90 days)
    # As https://developer.hashicorp.com/terraform/language/functions/timeadd does not support addind days, we are using hours.
    if = each.value.output.stdout.AccessKeyMetadata[0].Status == "Active" && timecmp(each.value.output.stdout.AccessKeyMetadata[0].CreateDate, timeadd(timestamp(), "-2160h")) < 0
    pipeline = aws.pipeline.update_iam_access_key_status
    args = {
      user_name = each.value.output.stdout.AccessKeyMetadata[0].UserName
      access_key_id = each.value.output.stdout.AccessKeyMetadata[0].AccessKeyId
      status = "Inactive"
    }
  }

  # TODO: Figure out how to iterate both over step.pipeline.list_iam_access_keys then over each.value.output.stdout.AccessKeyMetadata

  output "update_iam_access_key_status" {
    description = "List of access keys."
    value       = step.pipeline.update_iam_access_key_status
  }

  output "access_keys" {
    description = "List of access keys."
    value       = step.pipeline.list_iam_access_keys
  }

  output "iam_users" {
    description = "List of IAM users."
    value       = step.pipeline.list_iam_users.output.stdout
  }
}
