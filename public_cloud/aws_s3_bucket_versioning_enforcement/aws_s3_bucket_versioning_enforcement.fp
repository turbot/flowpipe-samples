trigger "query" "find_deletable_buckets" {
  database    = var.database
  primary_key = "name"
  schedule    = var.schedule

  sql = <<EOQ
    select
      name
    from
      aws_s3_bucket
    where
      versioning_enabled = false
    order by
      name
  EOQ

  capture "insert" {
    pipeline = pipeline.new_buckets
    args = {
      buckets = self.inserted_rows[*].name
    }
  }
}

pipeline "new_buckets" {
  param "buckets" {
    type = list(string)
  }

  step "pipeline" "versioning_enforcement" {
    for_each = param.buckets
    pipeline = pipeline.versioning_enforcement
    args = {
      bucket = each.value
    }
  }
}

pipeline "versioning_enforcement" {
  param "bucket" {
    type = string
  }

  param "notifier" {
    type        = notifier
    description = "Notifier to use."
    default     = var.notifier
  }

  step "input" "ask_for_action" {
    notifier = param.notifier
    prompt   = "Bucket ${param.bucket} created with no versioning. What would you like to do?"
    type     = "button"

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
    if       = step.input.ask_for_action.value == "version"
    pipeline = aws.pipeline.put_s3_bucket_versioning
    args = {
      region     = var.aws_region
      conn       = var.aws_conn
      bucket     = param.bucket
      versioning = true
    }
  }

  step "pipeline" "delete" {
    if       = step.input.ask_for_action.value == "delete"
    pipeline = aws.pipeline.delete_s3_bucket
    args = {
      region = var.aws_region
      conn   = var.aws_conn
      bucket = param.bucket
    }
  }
}
