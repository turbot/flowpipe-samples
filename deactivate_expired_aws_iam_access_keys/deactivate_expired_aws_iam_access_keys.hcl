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
    for_each = concat([for keys in step.pipeline.list_iam_access_keys: keys.output.stdout.AccessKeyMetadata])
    # Run only if the access key is active and older than 90 days. (2160h = 90 days)
    # As https:#developer.hashicorp.com/terraform/language/functions/timeadd does not support addind days, we are using hours.
    if = each.value.Status == "Active" && timecmp(each.value.CreateDate, timeadd(timestamp(), "-2160h")) < 0
    pipeline = aws.pipeline.update_iam_access_key_status
    args = {
      user_name = each.value.UserName
      access_key_id = each.value.AccessKeyId
      status = "Inactive"
    }
  }

  // TODO find out a way to output the list of deactivated access keys. Currently the update_iam_access_key API doesn't return anything.

  output "update_iam_access_key_status" {
    description = "List of access keys."
    value       = step.pipeline.update_iam_access_key_status
  }

  # Reenable for debugging
  # output "access_keys" {
  #   description = "List of access keys."
  #   value       = step.pipeline.list_iam_access_keys
  # }

  # Reenable for debugging
  # output "iam_users" {
  #   description = "List of IAM users."
  #   value       = step.pipeline.list_iam_users.output.stdout
  # }

}
