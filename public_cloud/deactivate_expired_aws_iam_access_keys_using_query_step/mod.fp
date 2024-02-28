mod "deactivate_expired_aws_iam_access_keys_using_query_step" {
  title         = "Deactivate expired AWS IAM access keys Using Query Step"
  description   = "Deactivates expired AWS IAM access keys and notifies via email."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "0.1.0"
    }
  }

}
