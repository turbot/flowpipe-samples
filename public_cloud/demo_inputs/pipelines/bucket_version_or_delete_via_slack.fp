trigger "query" "find_deletable_buckets" {
  enabled           = true
  database = "postgres://steampipe@127.0.0.1:9193/steampipe"
  schedule          = "* * * * *"
  primary_key = "label"
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

  capture "insert" {
    pipeline = pipeline.new_buckets
    args = {
      buckets = self.inserted_rows[*].label
    }
  }
}

pipeline "new_buckets" {
  param "buckets" {
    type = list(string)
  }

  step "pipeline" "new_bucket" {
    for_each = param.buckets
    pipeline = pipeline.new_bucket
    args = {
      bucket = each.value
    }
  }
}

pipeline "new_bucket" {
  param "bucket" {
    type = string
  }

  step "input" "verify" {
    notifier  = notifier["slack"] 
    prompt    = "Bucket Created: ${param.bucket} - Next Action?"
    type      = "button"

    option "a" {
      label = "Ensure Versioning"
      value = "version"
    }

    option "b" {
      label = "Delete"
      value = "delete"
    }
  }

  step "pipeline" "ensure_version" {
    if        = step.input.verify.value == "version"
    pipeline  = aws.pipeline.put_s3_bucket_versioning
    args = {
      bucket      = param.bucket
      region      = "us-east-1"
      versioning  = true
      cred        = "dundermifflin"
    }
  }

  step "pipeline" "delete" {
    if        = step.input.verify.value == "delete"
    pipeline = aws.pipeline.delete_s3_bucket  
    args = {
      bucket = param.bucket
      region = "us-east-1"
      cred   = "dundermifflin"
    }
  }
}

