mod "query_and_stop_aws_ec2_instances_by_tag" {
  title         = "Query and Stop AWS EC2 Instances by Tag"
  description   = "Query and stop AWS EC2 instance based on the `status` tag value."
  documentation = file("./README.md")
  categories    = ["public cloud", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "^1"
    }
  }
}
