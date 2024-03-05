mod "aws_ec2_instance_scheduler" {
  title         = "AWS EC2 Instance Scheduler"
  description   = "Schedule EC2 instances to start and stop at specific times and optionally notify via Teams."
  documentation = file("./README.md")
  categories    = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.1"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "0.1.0"
    }
  }
}
