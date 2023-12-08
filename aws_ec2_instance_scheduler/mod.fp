mod "aws_ec2_instance_scheduler" {
  title       = "AWS EC2 Instance Scheduler"
  description = "Schedule EC2 instances to start and stop at specific times"

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.7"
      args = {
        region = var.aws_region
        // region = "us-east-1"
      }
    }
  }
}
