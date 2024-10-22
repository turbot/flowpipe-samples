pipeline "query_and_stop_aws_ec2_instances_by_tag" {
  title       = "Query and Stop AWS EC2 Instances by Tag"
  description = "Query and stop AWS EC2 instance based on the `status` tag value."

  param "aws_region" {
    type        = string
    description = "The name of the Region."
    default     = var.aws_region
  }

  param "aws_conn" {
    type        = connection.aws
    description = "Name for AWS connection to use. If not provided, the default connection will be used."
    default     = var.aws_conn
  }

  step "query" "list_ec2_instances" {
    database = "postgres://steampipe@localhost:9193/steampipe"

    sql = <<-EOQ
      select
        instance_id
      from
        aws_ec2_instance
      where
        instance_state = 'running'
        and tags ->> 'status' = 'decom'
    EOQ
  }

  step "pipeline" "stop_aws_ec2_instances" {
    for_each = step.query.list_ec2_instances.rows
    pipeline = aws.pipeline.stop_ec2_instances
    args = {
      region       = param.aws_region
      conn         = param.aws_conn
      instance_ids = ["${each.value.instance_id}"]
    }
  }

  output "stopped_instances" {
    description = "Stopped instances."
    value       = join(", ", [for instance in values(step.pipeline.stop_aws_ec2_instances) : instance.output.instances[0].InstanceId])
  }
}
