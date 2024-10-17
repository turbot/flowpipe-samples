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
    pipeline = pipeline.create_iam_access_key_event

    args = {
      access_keys = self.inserted_rows
    }
  }

  capture "update" {
    pipeline = pipeline.update_iam_access_key_event

    args = {
      access_keys = self.updated_rows
    }
  }

  capture "delete" {
    pipeline = pipeline.delete_iam_access_key_event

    args = {
      access_keys = self.deleted_rows
    }
  }
}

pipeline "create_iam_access_key_event" {
  title       = "Create IAM Access Key Event"
  description = "Send a notification for new access keys."

  param "access_keys" {
    type        = list
    description = "Row data for IAM access keys."
  }

  param "notifier" {
    type        = notifier
    description = "Notifier to use."
    default     = var.notifier
  }

  step "message" "notify_iam_access_key_created" {
    for_each = param.access_keys
    notifier = param.notifier
    text     = "New IAM access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] created at ${each.value.create_date}"
  }
}

pipeline "update_iam_access_key_event" {
  title       = "Update IAM Access Key Event"
  description = "Send a notification for access key updates."

  param "access_keys" {
    type        = list
    description = "Row data for IAM access keys."
  }

  param "notifier" {
    type        = notifier
    description = "Notifier to use."
    default     = var.notifier
  }

  step "message" "notify_iam_access_key_updated" {
    for_each = param.access_keys
    notifier = param.notifier
    text     = "Access key ${each.value.access_key_id} for ${each.value.user_name} [${each.value.account_id}] status is now ${each.value.status}"
  }
}

pipeline "delete_iam_access_key_event" {
  title       = "Delete IAM Access Key Event"
  description = "Send a notification for deleted access keys."

  param "access_keys" {
    type        = list
    description = "Row data for IAM access keys."
  }

  param "notifier" {
    type        = notifier
    description = "Notifier to use."
    default     = var.notifier
  }

  step "message" "notify_iam_access_key_deleted" {
    for_each = param.access_keys
    notifier = param.notifier
    text     = "IAM access key ${each.value} has been deleted"
  }
}
