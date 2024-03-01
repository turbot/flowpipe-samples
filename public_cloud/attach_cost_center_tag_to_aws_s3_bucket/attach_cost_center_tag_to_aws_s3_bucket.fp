trigger "query" "attach_cost_center_tag_to_aws_s3_bucket" {
  database    = var.database
  primary_key = "arn"
  schedule    = var.schedule

  sql = <<EOQ
    select
      arn
    from
      aws_s3_bucket,
      jsonb_array_elements(tags_src) as tag
    where
      tag ->> 'Key' <> 'cost_center';
  EOQ

  capture "insert" {
    pipeline = pipeline.new_buckets
    args = {
      buckets = self.inserted_rows[*].arn
    }
  }
}

pipeline "new_buckets" {
  param "buckets" {
    type = list(string)
  }

  step "pipeline" "attach_cost_center_tag" {
    for_each = param.buckets
    pipeline = pipeline.attach_cost_center_tag
    args = {
      bucket = each.value
    }
  }
}

pipeline "attach_cost_center_tag" {
  param "bucket" {
    type = string
  }

  step "input" "attach_cost_center_tag" {
    notifier = notifier[var.notifier]
    type     = "select"
    prompt   = "Select a cost center:"

    option "foo" {}
    option "bar" {}
    option "baz" {}
  }

  step "pipeline" "attach_tag" {
    pipeline = aws.pipeline.tag_resources
    args = {
      region        = var.aws_region
      cred          = var.aws_cred
      resource_arns = ["${param.bucket}"]
      tags          = { "cost_center" : "${step.input.attach_cost_center_tag.value}" }
    }
  }

  step "message" "notifier" {
    notifier = notifier[var.notifier]
    subject  = "Tag Update: ${param.bucket}"
    body     = "Attached tag {cost_center:${step.input.attach_cost_center_tag.value}} to ${param.bucket}"
  }
}
