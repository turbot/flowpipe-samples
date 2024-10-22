trigger "query" "list_iam_access_keys" {
  title       = "List IAM Access Keys"
  description = "List IAM access keys with information related to create, update, and delete events."
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

  param "notifier" {
    type        = notifier
    description = "Notifier to use."
    default     = var.notifier
  }

  step "message" "notify_new_iam_access_keys" {
    for_each = param.inserted_access_keys != null ? param.inserted_access_keys : []
    notifier = param.notifier
    text     = "New IAM access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] created at ${each.value.create_date}"
  }

  step "message" "notify_iam_access_key_updated" {
    for_each = param.updated_access_keys != null ? param.updated_access_keys : []
    notifier = param.notifier
    text     = "Access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] status is now ${each.value.status}"
  }

  step "message" "notify_iam_access_key_deleted" {
    for_each = param.deleted_access_keys != null ? param.deleted_access_keys : []
    notifier = param.notifier
    text     = "IAM access key ${each.value} has been deleted"
  }

}
