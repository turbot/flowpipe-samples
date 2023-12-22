pipeline "query_and_stop_aws_ec2_instance" {
  title       = "Query and Stop AWS EC2 Instance"
  description = "Query and Stop AWS EC2 Instance based on the tag value."

  param "aws_region" {
    type        = string
    description = "The name of the Region."
    default     = var.aws_region
  }

  param "aws_cred" {
    type        = string
    description = "Name for AWS credential to use. If not provided, the default credential will be used."
    default     = var.aws_cred
  }

  # List EC2 instances which need to stop
  step "query" "list_ec2_instances" {
    connection_string = "postgres://steampipe@localhost:9193/steampipe"
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

  # Stop the EC2 instances
  step "pipeline" "aws_ec2_instance_stop" {
    for_each = step.query.list_ec2_instances.rows
    pipeline = aws.pipeline.stop_ec2_instances
    args = {
      region       = param.aws_region
      cred         = param.aws_cred
      instance_ids = ["${each.value.instance_id}"]
    }
  }
}
