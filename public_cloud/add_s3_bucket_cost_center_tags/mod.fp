mod "add_s3_bucket_cost_center_tags" {
  title         = "Add S3 Bucket Cost Center Tags"
  description   = "Find S3 buckets without the 'cost_center' tag and add the tag with a user selected value."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.0"
    }
  }
}
