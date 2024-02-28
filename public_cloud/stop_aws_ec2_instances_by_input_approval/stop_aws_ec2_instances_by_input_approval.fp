pipeline "stop_aws_ec2_instances_by_input_approval" {
  title       = "Query and Stop AWS EC2 Instances by Input Approval"
  description = "Query and stop AWS EC2 instance based on the input approval."

  step "query" "list_ec2_instances" {
    database = "postgres://steampipe@localhost:9193/steampipe"
    sql      = <<EOQ
    select
      instance_id,
      region,
      _ctx ->> 'connection_name' as connection
    from
      aws_ec2_instance
    where
      instance_state = 'running';
  EOQ
  }

  step "pipeline" "fetch_each_ec2_instance" {
    for_each = step.query.list_ec2_instances.rows
    pipeline = pipeline.stop_aws_ec2_instances_based_on_approval
    args = {
      instance_id = each.value.instance_id
      aws_region  = each.value.region
      aws_cred    = each.value.connection
    }
  }
}

pipeline "stop_aws_ec2_instances_based_on_approval" {


  param "instance_id" {
    type = string
  }

  param "aws_region" {
    type        = string
    description = "The name of the Region."
  }

  param "aws_cred" {
    type        = string
    description = "Name for AWS credential to use. If not provided, the default credential will be used."
    default     = var.aws_cred
  }

  step "input" "stop_ec2_instances" {
    notifier = notifier["slack"]
    prompt   = "Do you want to stop the EC2 instance: ${param.instance_id}?"
    type     = "button"

    option "Yes" {
      label = "Yes"
      value = "yes"
    }
  }

  step "pipeline" "stop_aws_ec2_instances" {
    if       = step.input.stop_ec2_instances.value == "yes"
    pipeline = aws.pipeline.stop_ec2_instances
    args = {
      region       = param.aws_region
      cred         = param.aws_cred
      instance_ids = ["${param.instance_id}"]
    }
  }
}
