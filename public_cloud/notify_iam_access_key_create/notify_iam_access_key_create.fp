trigger "query" "new_access_keys" {
  database    = "postgres://steampipe@localhost:9193/steampipe"
  primary_key = "message"
  schedule    = "5m"

  sql = <<EOQ
    select
      'New access key ' || access_key_id || ' is created by ' || user_name || ' at ' || create_date as message
    from
      aws_iam_access_key
    where
      create_date > now() - interval '1 day';
  EOQ


  capture "insert" {
    pipeline = pipeline.notify_slack_iam_access_key_create

    args = {
      rows = self.inserted_rows
    }
  }
}

pipeline "notify_iam_access_key_create" {
  title       = "Notify New IAM Access Key Create"
  description = "Notify a slack channel or email when a new IAM access key is created."

  param "rows" {
    type = list
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
    default     = var.notifier
  }

  step "message" "notifier" {
    for_each = param.rows
    notifier = notifier[param.notifier]
    subject  = "New AWS IAM Access Key Created"
    text     = each.value.message
  }
}
