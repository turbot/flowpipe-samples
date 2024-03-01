pipeline "deactivate_expired_aws_iam_access_keys_using_query_step" {
  title       = "Deactivate expired AWS IAM access keys Using Query Step"
  description = "Deactivates expired AWS IAM access keys and notifies via email."

  step "query" "list_iam_access_keys" {
    database = var.database
    sql      = <<-EOQ
      select
        access_key_id,
        user_name,
        _ctx ->> 'connection_name' as connection
      from
        aws_iam_access_key
      where
        create_date < now() - interval '90 days'
        and status = 'Active';
    EOQ
  }

  step "pipeline" "update_iam_access_key" {
    for_each = step.query.list_iam_access_keys.rows
    pipeline = aws.pipeline.update_iam_access_key
    args = {
      cred          = each.value.connection
      user_name     = each.value.user_name
      access_key_id = each.value.access_key_id
      status        = "Inactive"
    }
  }

  step "message" "notifier" {
    notifier = notifier[var.notifier]
    subject  = "Deactivated expired AWS IAM Keys"
    text     = jsonencode(step.query.list_iam_access_keys.rows)
  }
}
