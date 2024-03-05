trigger "query" "list_s3_buckets_without_cost_center_tag" {
  title       = "List S3 Buckets Without Cost Center Tag"
  description = "Find S3 buckets missing the cost_center tag key."
  database    = var.database
  schedule    = "* * * * *" # Every minute
  primary_key = "name"

  sql = <<-EOQ
    select
      name,
      arn,
      account_id,
      region,
      _ctx ->> 'connection_name' as conn_name
    from
      aws_s3_bucket
    where
      tags ->> 'cost_center' is null
  EOQ

  capture "insert" {
    pipeline = pipeline.add_s3_bucket_cost_center_tags
    args = {
      buckets = self.inserted_rows
    }
  }
}

pipeline "add_s3_bucket_cost_center_tags" {
  title       = "Add S3 Bucket Cost Center Tags"
  description = "Add the cost_center tag to S3 buckets based on user input."

  param "buckets" {
    type        = list
    description = "Row data for S3 buckets."
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
    default     = var.notifier
  }

  step "pipeline" "add_cost_center_tag_to_s3_bucket" {
    for_each = param.buckets
    pipeline = pipeline.add_cost_center_tag_to_s3_bucket
    args = {
      bucket   = each.value
      notifier = param.notifier
    }
  }

}

pipeline "add_cost_center_tag_to_s3_bucket" {
  title       = "Add Cost Center Tag to S3 Bucket"
  description = "Add the cost_center tag to an S3 bucket with a value based on user input."

  param "bucket" {
    type        = map(string)
    description = "Row data for S3 bucket."
  }

  param "notifier" {
    type        = string
    description = "Notifier to use."
  }

  step "input" "prompt_select_cost_center_tag_value" {
    notifier = notifier[param.notifier]
    subject  = "Request to add cost_center tag to S3 bucket ${param.bucket.name} [${param.bucket.account_id} ${param.bucket.region}]"
    prompt   = "Select a cost_center tag value for S3 bucket ${param.bucket.name} [${param.bucket.account_id} ${param.bucket.region}]:"
    type     = "select"

    options = [
      {
        label    = "Accounting (12345)"
        value    = "12345"
        selected = true
      },
      {
        label = "HR (67890)"
        value = "67890"
      },
      {
        label = "IT (24680)"
        value = "24680"
      },
      {
        label = "Marketing (13579)"
        value = "13579"
      }
    ]
  }

  step "pipeline" "add_tag_to_s3_bucket" {
    pipeline = aws.pipeline.tag_resources
    args = {
      cred          = param.bucket.conn_name
      resource_arns = [param.bucket.arn]
      region        = param.bucket.region

      tags = {
        "cost_center": step.input.prompt_select_cost_center_tag_value.value
      }
    }
  }

  step "message" "notify_s3_bucket_tagged" {
    notifier = notifier[param.notifier]
    text     = "Added cost_center:${step.input.prompt_select_cost_center_tag_value.value} to S3 bucket ${param.bucket.name} [${param.bucket.account_id} ${param.bucket.region}]"
  }
}
