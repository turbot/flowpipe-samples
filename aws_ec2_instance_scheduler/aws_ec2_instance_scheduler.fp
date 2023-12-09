pipeline "aws_ec2_instance_scheduler" {
  title       = "AWS EC2 Instance Scheduler"
  description = "Pipeline for AWS EC2 Instance Scheduling using cron jobs."

  param "aws_region" {
    description = "The AWS region to use."
    type        = string
    default     = var.aws_region
  }

  param "aws_cred" {
    description = "Name for credentials to use. If not provided, the default credentials will be used."
    type        = string
    default     = "default"
  }

  param "schedule_name" {
    description = "The name of the tag that is used to identify the schedule."
    type    = string
  }

  param "action" {
    description = "The action to perform on the EC2 instances. Valid values are 'start' and 'stop'."
    type    = string
  }

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

  step "transform" "scheduled_instance_ids" {
    value = [for instance in step.pipeline.describe_ec2_instances.output.instances[*] : instance.InstanceId ]
  }

  step "pipeline" "aws_ec2_instance_start" {
    if          = param.action == "start"
    description = "Starts the EC2 instances"
    pipeline    = aws.pipeline.start_ec2_instances
    args = {
      region       = param.aws_region
      cred         = param.aws_cred
      instance_ids = step.transform.scheduled_instance_ids.value
    }
  }

  step "pipeline" "aws_ec2_instance_stop" {
    if          = param.action == "stop"
    description = "Stops the EC2 instances"
    for_each    = step.transform.scheduled_instance_ids.value
    pipeline    = aws.pipeline.stop_ec2_instances
    args = {
      region       = param.aws_region
      cred         = param.aws_cred
      instance_ids = step.transform.scheduled_instance_ids.value
    }
  }

}

// // trigger "schedule" "after_1_min" {
// //   schedule = "*/1 * * * *"
// //   pipeline = pipeline.aws_ec2_instance_scheduler
// //   args = {
// //     schedule_name = "after_1_min"
// //     action        = "start"
// //   }
// // }

// // Business hours (8:00am - 6:00pm on weekdays)
// trigger "schedule" "business_hours_start" {
//   schedule = "0 8 * * 1-5"
//   pipeline = pipeline.aws_ec2_instance_scheduler
//   args = {
//     schedule_name = "business_hours"
//     action        = "start"
//   }
// }

// trigger "schedule" "business_hours_stop" {
//   schedule = "0 18 * * 1-5"
//   pipeline = pipeline.aws_ec2_instance_scheduler
//   args = {
//     schedule_name = "business_hours"
//     action        = "stop"
//   }
// }

// // Extended business hours (7:00am - 11:00pm on weekdays)
// trigger "schedule" "extended_business_hours_start" {
//   schedule = "0 7 * * 1-5"
//   pipeline = pipeline.aws_ec2_instance_scheduler
//   args = {
//     schedule_name = "extended_business_hours"
//     action        = "start"
//   }
// }

// trigger "schedule" "extended_business_hours_stop" {
//   schedule = "0 23 * * 1-5"
//   pipeline = pipeline.aws_ec2_instance_scheduler
//   args = {
//     schedule_name = "extended_business_hours"
//     action        = "stop"
//   }
// }

// // Stop for night (stop at 10:00pm every day)
// trigger "schedule" "stop_for_night" {
//   schedule = "0 22 * * *"
//   pipeline = pipeline.aws_ec2_instance_scheduler
//   args = {
//     schedule_name = "stop_for_night"
//     action        = "stop"
//   }
// }

// //  Stop for Weekend at 10:00 PM
// trigger "schedule" "stop_for_weekend" {
//   schedule = "0 22 * * 5"
//   pipeline = pipeline.aws_ec2_instance_scheduler
//   args = {
//     schedule_name = "stop_for_weekend"
//     action        = "stop"
//   }
// }
