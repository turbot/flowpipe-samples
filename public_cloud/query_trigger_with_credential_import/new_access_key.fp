trigger "query" "new_aws_iam_access_key" {
  description       = "Fire when a new key appears, call email-notifying pipeline"
  database           = "postgres://steampipe@localhost:9193/steampipe"
  schedule          = "* * * * *"    # every minute
  primary_key       = "message"
  sql               = <<EOQ
    select user_name || ': ' || create_date as message
    from aws_iam_access_key
    where create_date > now() - interval '1 week'
  EOQ

  capture "insert" {
    pipeline = pipeline.notify_new_access_key
    args = {
      rows = self.inserted_rows
    }
  }

}


pipeline "notify_new_access_key" {

  param "rows" {
    type = list
  }

  step "pipeline" "send_email" {
    pipeline = pipeline.send_email
    for_each = param.rows
    args = {
      smtp_username = "judell@turbot.com"
      smtp_host     = "smtp.gmail.com"
      subject       = "New access key detected"
      message       = each.value.message
    }
  }
  
}


