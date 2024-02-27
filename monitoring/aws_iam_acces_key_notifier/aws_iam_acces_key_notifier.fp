trigger "query" "expired_access_keys" {
  database    = "postgres://steampipe@localhost:9193/steampipe"
  primary_key = "access_key_id"
  schedule    = "5m"

  sql = <<EOQ
      select
        access_key_id,
        status,
        user_name,
        _ctx ->> 'connection_name' as connection
      from
        aws_iam_access_key;
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
    for_each = param.access_keys

    subject = "IAM Access Key created for ${each.value.user_name}"
    body    = <<-EOS
      <p>An IAM Access Key was created for user <b>${each.value.user_name}</b> at <b>${timestamp()}</b></p>
    EOS
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
    for_each = param.access_keys

    subject = "IAM Access Key changed for ${each.value.user_name}"
    body    = <<-EOS
      <p>An IAM Access Key was changed to ${each.value.status} for user <b>${each.value.user_name}</b> at <b>${timestamp()}</b></p>
    EOS
  }

  output "updated_access_keys" {
    value = param.access_keys
  }
}

pipeline "deleted_access_keys" {
  param "access_keys" {
    type = list
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
