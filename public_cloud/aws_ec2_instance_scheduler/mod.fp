mod "aws_ec2_instance_scheduler" {
  title         = "AWS EC2 Instance Scheduler"
  description   = "Schedule EC2 instances to start and stop at specific times and optionally notify via Teams."
  documentation = file("./README.md")
  categories    = ["public cloud", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "^1"
    }
  }
}
