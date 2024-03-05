trigger "query" "list_new_iam_access_keys" {
  database    = var.database
  primary_key = "access_key_id"
  schedule    = "* * * * *" # Every minute

  sql = <<EOQ
    select
      access_key_id,
      user_name,
      create_date,
      account_id
    from
      aws_iam_access_key
    where
      create_date > now() - interval '1 day';
  EOQ


  capture "insert" {
    pipeline = pipeline.notify_new_iam_access_key_created

    args = {
      access_keys = self.inserted_rows
    }
  }
}

pipeline "notify_new_iam_access_key_created" {
  title       = "Notify New IAM Access Key Created"
  description = "Send a notification when a new IAM access key is created."

  param "access_keys" {
    type        = list
    description = "Row data for IAM access keys."
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
    default     = var.notifier
  }

  step "message" "notify_new_iam_access_key" {
    for_each = param.access_keys
    notifier = notifier[param.notifier]
    text     = "New IAM access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] created at ${each.value.create_date}"
  }
}
