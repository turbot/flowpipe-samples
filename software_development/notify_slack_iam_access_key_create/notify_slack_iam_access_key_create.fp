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

pipeline "notify_slack_iam_access_key_create" {
  title       = "Notify Slack for New IAM Access Key Create"
  description = "Notify a Slack channel when a new IAM access key is created."

  param "rows" {
    type = list
  }

  param "slack_cred" {
    type        = string
    description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
    default     = var.slack_channel
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    for_each = param.rows
    args = {
      cred    = param.slack_cred
      channel = param.slack_channel
      text    = each.value.message
    }
  }
}
