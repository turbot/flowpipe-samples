pipeline "deactivate_longstanding_aws_iam_access_keys" {
  title = "Deactivate longstanding AWS IAM access keys"
  description = "Deactivates longstanding AWS IAM access keys."

  step "pipeline" "list_iam_users" {
    pipeline = aws.pipeline.list_iam_users
  }

  step "pipeline" "list_access_keys" {
    for_each = step.pipeline.list_iam_users.output.stdout.Users
    pipeline = aws.pipeline.list_access_keys
    args = {
      user_name = each.value.UserName
    }
  }

  // step "pipeline" "update_access_key" {
  step "echo" "update_access_key" {
    // for_each = step.pipeline.list_iam_users.output.stdout.Users
    for_each = step.pipeline.list_access_keys[*].output.stdout.AccessKeyMetadata
    text = each.value.UserName
    # Run only if the access key is active and older than 90 days.
    // if = each.value.Status == "Active" && each.value.CreateDate < time.now - "90d"
    // text = each.value
    // pipeline = aws.pipeline.update_access_key
    // args = {
    //   user_name = each.value.UserName
    //   access_key_id = each.value.AccessKeyId
    //   status = "Inactive"
    // }
  }

  // output "update_access_key" {
  //   description = "List of access keys."
  //   value       = step.echo.update_access_key
  // }

  // output "access_keys" {
  //   description = "List of access keys."
  //   value       = step.pipeline.list_access_keys
  // }

  // output "iam_users" {
  //   description = "List of IAM users."
  //   value       = step.pipeline.list_iam_users.output.stdout
  // }
}
