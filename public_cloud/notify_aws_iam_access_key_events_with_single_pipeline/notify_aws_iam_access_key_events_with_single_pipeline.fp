trigger "query" "list_iam_access_keys" {
  database    = var.database
  primary_key = "access_key_id"
  schedule    = "* * * * *" # Every minute

  sql = <<EOQ
    select
      access_key_id,
      status,
      user_name,
      create_date,
      account_id
    from
      aws_iam_access_key;
  EOQ

  capture "insert" {
    pipeline = pipeline.handle_iam_access_key_events

    args = {
      inserted_access_keys = self.inserted_rows
    }
  }

  capture "update" {
    pipeline = pipeline.handle_iam_access_key_events

    args = {
      updated_access_keys = self.updated_rows
    }
  }

  capture "delete" {
    pipeline = pipeline.handle_iam_access_key_events

    args = {
      deleted_access_keys = self.deleted_rows
    }
  }
}

pipeline "handle_iam_access_key_events" {
  title       = "Handle IAM Access Key Events"
  description = "Send a notification for access key create, update, and delete events."

  param "inserted_access_keys" {
    type        = list
    description = "Row data for new IAM access keys."
    optional    = true
  }

  param "updated_access_keys" {
    type        = list
    description = "Row data for updated IAM access keys."
    optional    = true
  }

  param "deleted_access_keys" {
    type        = list
    description = "Row data for deleted IAM access keys."
    optional    = true
  }

  step "message" "notify_new_iam_access_keys" {
    if       = param.inserted_access_keys != null
    for_each = param.inserted_access_keys
    notifier = notifier[var.notifier]
    text     = "New IAM access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] created at ${each.value.create_date}"
  }

  step "message" "notify_iam_access_key_updated" {
    if       = param.updated_access_keys != null
    for_each = param.updated_access_keys
    notifier = notifier[var.notifier]
    text     = "Access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] status is now ${each.value.status}"
  }

  step "message" "notify_iam_access_key_deleted" {
    if       = param.deleted_access_keys != null
    for_each = param.deleted_access_keys
    notifier = notifier[var.notifier]
    text     = "IAM access key ${each.value} has been deleted"
  }

}