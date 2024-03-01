mod "stop_aws_ec2_instances_by_input_approval" {
  title         = "Stop AWS EC2 Instances by Input Approval"
  description   = "Stop AWS EC2 instance based on the input approval."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "0.1.0"
    }
  }
}
