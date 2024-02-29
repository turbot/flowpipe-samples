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
      access_keys = self.inserted_rows
    }
  }
}

pipeline "deactivate_expired_aws_iam_access_keys_with_approval" {
  title       = "Deactivate Expired AWS IAM Access Keys with Approval"
  description = "Deactivate expired AWS IAM access keys with approval."

  param "access_keys" {
    type        = list
    description = "Row data for IAM access keys."
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
    default     = var.notifier
  }

  step "pipeline" "deactivate_expired_iam_access_keys" {
    for_each = param.access_keys
    pipeline = pipeline.deactivate_iam_access_keys_with_approval
    args = {
      access_key = each.value
      notifier   = param.notifier
    }
  }

  output "expired_access_keys" {
    value = param.access_keys
  }

}

pipeline "deactivate_iam_access_keys_with_approval" {
  title       = "Deactivate IAM Access Keys with Approval"
  description = "Deactivate IAM access keys with approval or just send a notification."

  param "access_key" {
    type        = map(string)
    description = "Row data for IAM access key."
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
  }

  step "input" "prompt_deactivate_expired_aws_iam_access_key" {
    notifier = notifier[param.notifier]
    subject  = "Request to deactivate expired IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} [${param.access_key.account_id}]"
    prompt   = "Do you want to deactivate IAM access key ${param.access_key.access_key_id} belonging to ${param.access_key.user_name} [${param.access_key.account_id}]?"
    type     = "button"

    option "Deactivate" {
      label = "Deactivate"
      value = "deactivate"
      style = "alert"
    }

    option "Escalate" {
      label = "Escalate"
      value = "escalate"
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
    text     = "Deactivated IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} [${param.access_key.account_id}]"
  }

  step "message" "alert_iam_access_key_expired" {
    if = step.input.prompt_deactivate_expired_aws_iam_access_key.value == "escalate"

    notifier = notifier[param.notifier]
    text     = "IAM access key ${param.access_key.access_key_id} for user ${param.access_key.user_name} [${param.access_key.account_id}] is expired"
  }

}
