pipeline "aws_ec2_instance_scheduler" {
  title       = "AWS EC2 Instance Scheduler"
  description = "Pipeline for AWS EC2 Instance Scheduling using cron jobs."

  param "aws_region" {
    description = "The AWS region to use."
    type        = string
    default     = var.aws_region
  }

  param "aws_cred" {
    description = "Name for AWS credential to use. If not provided, the default credential will be used."
    type        = string
    default     = "default"
  }

  param "teams_cred" {
    description = "Name for Teams credential to use. If not provided, the default credential will be used."
    type        = string
    default     = "default"
  }

  param "team_id" {
    description = "The unique identifier of the team."
    type        = string
  }

  param "teams_channel_id" {
    description = "The unique identifier for the Teams channel."
    type        = string
  }

  param "schedule_name" {
    description = "The name of the tag that is used to identify the schedule."
    type    = string
  }

  param "action" {
    description = "The action to perform on the EC2 instances. Valid values are 'start' and 'stop'."
    type    = string
  }

  # List EC2 instances with the given schedule name
  step "pipeline" "describe_ec2_instances" {
    pipeline = aws.pipeline.describe_ec2_instances
    args = {
      region = param.aws_region
      cred   = param.aws_cred
      tags   = {
        schedule_name = param.schedule_name
      }
    }
  }

  # Transform the EC2 instance IDs into a list
  step "transform" "scheduled_instance_ids" {
    value = [for instance in step.pipeline.describe_ec2_instances.output.instances[*] : instance.InstanceId ]
  }

  # Start the EC2 instances
  step "pipeline" "aws_ec2_instance_start" {
    if          = param.action == "start"
    pipeline    = aws.pipeline.start_ec2_instances
    args = {
      region       = param.aws_region
      cred         = param.aws_cred
      instance_ids = step.transform.scheduled_instance_ids.value
    }
  }

  # Stop the EC2 instances
  step "pipeline" "aws_ec2_instance_stop" {
    if          = param.action == "stop"
    for_each    = step.transform.scheduled_instance_ids.value
    pipeline    = aws.pipeline.stop_ec2_instances
    args = {
      region       = param.aws_region
      cred         = param.aws_cred
      instance_ids = step.transform.scheduled_instance_ids.value
    }
  }

  # Send message to MS Teams channel about the action performed
  step "pipeline" "send_message" {
    pipeline = teams.pipeline.send_channel_message
    depends_on = [
      step.pipeline.aws_ec2_instance_start,
      step.pipeline.aws_ec2_instance_stop
    ]
    args = {
      cred                 = param.teams_cred
      team_id              = param.team_id
      channel_id           = param.teams_channel_id
      message_content_type = "html"
      message              = <<-EOT
      <b>Running ${param.action} action on EC2 instances with schedule name '${param.schedule_name}'</b><br/>
      ${join("<br/>", [for instance_id in step.transform.scheduled_instance_ids.value : instance_id])}
      EOT
    }
  }
}

# Business hours (8:00am - 6:00pm on weekdays)
trigger "schedule" "business_hours_start" {
  schedule = "0 8 * * 1-5"
  pipeline = pipeline.aws_ec2_instance_scheduler
  args = {
    schedule_name = "business_hours"
    action        = "start"
    # team_id       = "<your team id>"
    # teams_channel_id = "<your teams channel id>"
  }
}

trigger "schedule" "business_hours_stop" {
  schedule = "0 18 * * 1-5"
  pipeline = pipeline.aws_ec2_instance_scheduler
  args = {
    schedule_name = "business_hours"
    action        = "stop"
    # team_id       = "<your team id>"
    # teams_channel_id = "<your teams channel id>"
  }
}

# Extended business hours (7:00am - 11:00pm on weekdays)
trigger "schedule" "extended_business_hours_start" {
  schedule = "0 7 * * 1-5"
  pipeline = pipeline.aws_ec2_instance_scheduler
  args = {
    schedule_name = "extended_business_hours"
    action        = "start"
    # team_id       = "<your team id>"
    # teams_channel_id = "<your teams channel id>"
  }
}

trigger "schedule" "extended_business_hours_stop" {
  schedule = "0 23 * * 1-5"
  pipeline = pipeline.aws_ec2_instance_scheduler
  args = {
    schedule_name = "extended_business_hours"
    action        = "stop"
    # team_id       = "<your team id>"
    # teams_channel_id = "<your teams channel id>"
  }
}

# Stop for night (stop at 10:00pm every day)
trigger "schedule" "stop_for_night" {
  schedule = "0 22 * * *"
  pipeline = pipeline.aws_ec2_instance_scheduler
  args = {
    schedule_name = "stop_for_night"
    action        = "stop"
    # team_id       = "<your team id>"
    # teams_channel_id = "<your teams channel id>"
  }
}

#  Stop for Weekend at 10:00 PM
trigger "schedule" "stop_for_weekend" {
  schedule = "0 22 * * 5"
  pipeline = pipeline.aws_ec2_instance_scheduler
  args = {
    schedule_name = "stop_for_weekend"
    action        = "stop"
    # team_id       = "<your team id>"
    # teams_channel_id = "<your teams channel id>"
  }
}
