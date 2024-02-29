/*
trigger "query" "list_expired_iam_access_keys" {
  title       = "List Expired IAM Access Keys"
  description = "List expired IAM access keys."
  database    = var.database
  schedule    = "* * * * *" # Every minute
  primary_key = "access_key_id"

  sql = <<-EOQ
    select
      access_key_id,
      user_name,
      account_id,
      _ctx ->> 'connection_name' as conn_name
    from
      aws_iam_access_key
    where
      create_date < now() - interval '90 days'
      and status = 'Active';
  EOQ

  capture "insert" {
    pipeline = pipeline.deactivate_expired_aws_iam_access_keys_with_approval
    args = {
      rows = self.inserted_rows
    }
  }
}
*/

pipeline "deactivate_expired_aws_iam_access_keys_with_approval" {
  title       = "Deactivate Expired AWS IAM Access Keys with Approval"
  description = "Deactivates expired AWS IAM access keys with approval."

  param "database" {
    type        = string
    description = "Steampipe database connection string."
    default     = var.database
  }

  # TODO: Do we need to use credential_import to match Steampipe creds and Flowpipe creds?
  param "aws_cred" {
    type        = string
    description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
    default     = var.aws_cred
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
    default     = var.notifier
  }

  step "query" "list_expired_iam_access_keys" {
    database = param.database
    sql      = <<-EOQ
      select
        access_key_id,
        user_name,
        account_id,
        _ctx ->> 'connection_name' as conn_name
      from
        aws_iam_access_key
      where
        create_date < now() - interval '90 days'
        and status = 'Active';
    EOQ
  }

  step "pipeline" "deactivate_expired_iam_access_keys" {
    for_each = step.query.list_expired_iam_access_keys.rows
    pipeline = pipeline.deactivate_iam_access_keys_with_approval
    args = {
      access_key = each.value
      notifier   = param.notifier
    }
  }

  output "expired_access_keys" {
    value = step.query.list_expired_iam_access_keys
  }

}

pipeline "deactivate_iam_access_keys_with_approval" {
  title       = "Deactivate IAM Access Keys with Approval"
  description = "Deactivate IAM access keys with approval or just send a notification."

  param "access_key" {
    type        = map(string)
    description = "IAM access key row data."
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
  }

  step "input" "prompt_deactivate_expired_aws_iam_access_key" {
    notifier = notifier[param.notifier]
    prompt   = "Do you want to deactivate the IAM access key ${param.access_key.access_key_id} belonging to ${param.access_key.user_name} [${param.access_key.account_id}?]"
    type     = "button"

    option "Deactivate" {
      label = "Deactivate"
      value = "deactivate"
    }

    option "Alert" {
      label = "Alert"
      value = "alert"
    }
  }

  step "pipeline" "deactivate_aws_iam_access_key" {
    if       = step.input.prompt_deactivate_expired_aws_iam_access_key.value == "deactivate"
    pipeline = aws.pipeline.update_iam_access_key
    args = {
      cred          = param.access_key.conn_name
      user_name     = param.access_key.user_name
      access_key_id = param.access_key.access_key_id
      status        = "Inactive"
    }
  }

  step "message" "notify_iam_access_key_deactivated" {
    if         = step.input.prompt_deactivate_expired_aws_iam_access_key.value == "deactivate"
    depends_on = [step.pipeline.deactivate_aws_iam_access_key]

    notifier = notifier[param.notifier]
    subject  = "Deactivated IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} [${param.access_key.account_id}]"
    body     = "Deactivated IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} [${param.access_key.account_id}]"
  }

  step "message" "alert_iam_access_key_expired" {
    if = step.input.prompt_deactivate_expired_aws_iam_access_key.value == "alert"

    notifier = notifier[param.notifier]
    subject  = "IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} is expired [${param.access_key.account_id}]"
    body     = "IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} is expired [${param.access_key.account_id}]"
  }

}
