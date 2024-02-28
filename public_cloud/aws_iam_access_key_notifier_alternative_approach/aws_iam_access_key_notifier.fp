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
    pipeline = pipeline.process_changes

    args = {
      inserted_access_keys = self.inserted_rows
    }
  }
  capture "update" {
    pipeline = pipeline.process_changes

    args = {
      updated_access_keys = self.updated_rows
    }
  }
  capture "delete" {
    pipeline = pipeline.process_changes

    args = {
      deleted_access_keys = self.deleted_rows
    }
  }
}

pipeline "process_changes" {
  param "inserted_access_keys" {
    type     = list
    optional = true
  }
  param "updated_access_keys" {
    type     = list
    optional = true
  }
  param "deleted_access_keys" {
    type     = list
    optional = true
  }

  step "pipeline" "send_insert_notification" {
    if = param.inserted_access_keys != null
    pipeline = pipeline.send_email_notification

    args = {
      subject = "IAM Access Key created"
      body    = <<-EOS
        <p>
          An IAM Access Key was created for the following users, at ${timestamp()} :<br />
          ${join("\n", [for access_key in param.inserted_access_keys : "<b>${access_key.user_name}</b><br />"])}
        </p>
      EOS
    }
  }

  step "pipeline" "send_update_notification" {
    if = param.updated_access_keys != null
    pipeline = pipeline.send_email_notification

    args = {
      subject = "IAM Access Key changed"
      body    = <<-EOS
        <p>
          ${join("\n", [for access_key in param.updated_access_keys : "An IAM Access Key was changed to <b>${access_key.status}</b> for user <b>${access_key.user_name}</b><br />"])}
        </p>
      EOS
    }
  }

  step "pipeline" "send_delete_notification" {
    if = param.deleted_access_keys != null
    pipeline = pipeline.send_email_notification

    args = {
      subject = "IAM Access Key deleted"
      body    = <<-EOS
        <p>
          ${join("\n", [for access_key in param.deleted_access_keys : "The IAM Access Key <b>${access_key}</b> was deleted<br />"])}
        </p>
      EOS
    }
  }

  output "inserted_access_keys" {
    value = param.inserted_access_keys
  }
  output "updated_access_keys" {
    value = param.updated_access_keys
  }
  output "deleted_access_keys" {
    value = param.deleted_access_keys
  }
}

pipeline "send_email_notification" {

  param "subject" {
    type = string
  }

  param "body" {
    type = string
  }

  step "email" "send_it" {
    to                = var.email_destination_list
    from              = var.email_from
    smtp_username     = var.smtp_username
    smtp_password     = var.smtp_password
    host              = var.smtp_host
    port              = var.smtp_port
    content_type      = "text/html"
    subject           = param.subject
    body              = param.body
  }
}
