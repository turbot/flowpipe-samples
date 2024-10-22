pipeline "deactivate_expired_aws_iam_access_keys_using_query_step" {
  title       = "Deactivate Expired AWS IAM Access Keys Using Query Step"
  description = "Find expired keys using a query step, deactivate them, and send a notification."

  param "expire_after_days" {
    type        = number
    description = "Number of days after which the access key should be deactivated."
    default     = 90
  }

  param "database" {
    type        = string
    description = "Database to connect to."
    default     = var.database
  }

  param "notifier" {
    type        = notifier
    description = "Notifier to use."
    default     = var.notifier
  }

  step "query" "list_expired_iam_access_keys" {
    database = var.database
    sql      = <<-EOQ
      select
        access_key_id,
        user_name,
        account_id,
        _ctx ->> 'connection_name' as conn_name
      from
        aws_iam_access_key
      where
        create_date < now() - interval '${param.expire_after_days} days'
        and status = 'Active';
    EOQ
  }

  step "pipeline" "deactivate_iam_access_keys" {
    for_each = step.query.list_expired_iam_access_keys.rows
    pipeline = aws.pipeline.update_iam_access_key

    args = {
      conn          = each.value.conn_name
      access_key_id = each.value.access_key_id
      user_name     = each.value.user_name
      status        = "Inactive"
    }
  }

  step "message" "notify_iam_access_key_deactivated" {
    for_each   = step.query.list_expired_iam_access_keys.rows
    depends_on = [step.pipeline.deactivate_iam_access_keys]
    notifier   = notifier[param.notifier]
    text       = "Deactivated IAM access key ${each.value.access_key_id} for user ${each.value.user_name} [${each.value.account_id}]"
  }

}
