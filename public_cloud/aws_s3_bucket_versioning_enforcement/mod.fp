mod "aws_s3_bucket_versioning_enforcement" {
  title         = "AWS S3 Bucket Versioning Enforcement"
  description   = "This mod ensures that versioning is enabled for an S3 bucket."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.1"
    }
  }
}
