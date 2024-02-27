pipeline "bucket_delete" {
  step "query" "get_deletable_buckets" {
    database = "postgres://steampipe@127.0.0.1:9193/steampipe"
    sql = <<EOQ
      select
        name as label,
        name as value
      from
        aws_s3_bucket
      where
        name ~ 'delete-me'
      order by label;
    EOQ
  }

  step "input" "select_buckets" {
    notifier = notifier["email"]
    prompt  = "Please select the buckets to delete"
    type    = "multiselect"
    options = step.query.get_deletable_buckets.rows
  }

  step "pipeline" "delete_buckets" {
    for_each = step.input.select_buckets.value
    #pipeline = aws.pipeline.delete_s3_bucket      
    pipeline = pipeline.dryrun
    args = {
      bucket = each.value
      region = "us-east-1"
      cred   = "dundermifflin"
    }
    output "step_out" {
      value = "Deleting: ${each.value}"
    }
  }

  output "deleted_buckets" {
    value = step.input.select_buckets.value
  }

}

pipeline "dryrun" {

  param "bucket" { type = string  }
  param "region" { type = string  }
  param "cred"   { type = string}

  output "params" {
    value = param.bucket
  }

}