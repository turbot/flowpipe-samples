trigger "query" "expired_access_keys" {
  database    = "postgres://steampipe@localhost:9193/steampipe"
  primary_key = "access_key_id"
  schedule    = var.schedule

  sql = <<EOQ
      select
        access_key_id,
        status,
        user_name,
        _ctx ->> 'connection_name' as connection
      from
        aws_iam_access_key
      order by
        user_name;
  EOQ

  capture "insert" {
    pipeline = pipeline.inserted_access_keys

    args = {
        access_keys = self.inserted_rows
    }
  }
  capture "update" {
    pipeline = pipeline.updated_access_keys

    args = {
        access_keys = self.updated_rows
    }
  }
  capture "delete" {
    pipeline = pipeline.deleted_access_keys

    args = {
        access_keys = self.deleted_rows
    }
  }
}

pipeline "inserted_access_keys" {
  param "access_keys" {
    type = list
  }

  step "pipeline" "send_email_notification" {
    pipeline = pipeline.send_email_notification

    args = {
      subject = "IAM Access Key created"
      body    = <<-EOS
        <p>
          An IAM Access Key was created for the following users,  at ${timestamp()} :<br />
          ${join("\n", [for access_key in param.access_keys : "<b>${access_key.user_name}</b><br />"])}
        </p>
      EOS
    }
  }

  output "inserted_access_keys" {
    value = param.access_keys
  }
}

pipeline "updated_access_keys" {
  param "access_keys" {
    type = list
  }

  step "pipeline" "send_email_notification" {
    pipeline = pipeline.send_email_notification

    args = {
      subject = "IAM Access Key changed"
      body    = <<-EOS
        <p>
          ${join("\n", [for access_key in param.access_keys : "An IAM Access Key was changed to <b>${access_key.status}</b> for user <b>${access_key.user_name}</b><br />"])}
        </p>
      EOS
    }
  }

  output "updated_access_keys" {
    value = param.access_keys
  }
}

pipeline "deleted_access_keys" {
  param "access_keys" {
    type = list
  }

  step "pipeline" "send_email_notification" {
    pipeline = pipeline.send_email_notification

    args = {
      subject = "IAM Access Key deleted"
      body    = <<-EOS
        <p>
          ${join("\n", [for access_key in param.access_keys : "The IAM Access Key <b>${access_key}</b> was deleted<br />"])}
        </p>
      EOS
    }
  }

  output "deleted_access_keys" {
    value = param.access_keys
  }
}

pipeline "send_email_notification" {

  param "subject" {
    type = string
  }

  param "body" {
    type = string
  }

  step "message" "send_message" {
    notifier = notifier.email
    subject  = param.subject
    body     = param.body
  }
}
