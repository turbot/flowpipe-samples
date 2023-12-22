mod "query_and_stop_aws_ec2_instance" {
  title         = "Query and Stop AWS EC2 Instance"
  description   = "Query and Stop AWS EC2 Instance based on the tag value."
  documentation = file("./README.md")
  categories    = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "0.1.0"
    }
  }
}
