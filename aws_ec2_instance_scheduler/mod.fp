mod "aws_ec2_instance_scheduler" {
  title       = "AWS EC2 Instance Scheduler"
  description = "Schedule EC2 instances to start and stop at specific times and notify via Teams."

  opengraph {
    title       = "AWS EC2 Instance Scheduler"
    description = "Schedule EC2 instances to start and stop at specific times and notify via Teams."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.16"
      args = {
        region = var.aws_region
      }
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.17"
    }
  }
}
