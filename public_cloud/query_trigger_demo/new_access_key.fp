trigger "query" "new_aws_iam_access_key" {
  description       = "Fire when a new key appears, call a notifier."
  database           = "postgres://steampipe@localhost:9193/steampipe"
  schedule          = "* * * * *"    # every minute
  primary_key       = "access_key_id"
  sql               = <<EOQ
    select access_key_id, account_id, user_name, create_date
    from aws_iam_access_key
    where create_date > now() - interval '2 weeks'
  EOQ

  capture "insert" {
    pipeline = pipeline.notify_new_access_key
    args = {
      rows = self.inserted_rows
    }
  }

}

pipeline "notify_new_access_key" {
  description = "Loop over new access keys, send each to notifier."

  param "rows" {
    type = list
  }

  step "message" "notify" {
    notifier = notifier["new_access_key"]
    for_each = param.rows
    body = "New access key for ${each.value.user_name}, ${each.value.account_id}: ${each.value.access_key_id},  ${each.value.create_date}"
  }  
  
}


/*
pipeline "test" {

  step "query" "find" {
    database           = "postgres://steampipe@localhost:9193/steampipe"
    sql = <<EOQ
      select access_key_id, user_name, create_date
      from aws_iam_access_key
      where create_date > now() - interval '1 month'
      limit 1
    EOQ
  }

  step "pipeline" "notify" {
    pipeline = pipeline.notify_new_access_key
    args = {
      rows = step.query.find.rows
    }
  }

}
*/


