mod "attach_cost_center_tag_to_aws_s3_bucket" {
  title         = "Attach AWS Cost Center Tag to S3 Bucket"
  description   = "Attach an AWS cost center tag to an S3 bucket."
  documentation = file("./README.md")
  categories    = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "0.1.0"
    }
  }
}
