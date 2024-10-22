mod "aws_iam_access_key_events_notifier_with_multiple_pipelines" {
  title         = "AWS IAM Access Key Events Notifier with Multiple Pipelines"
  description   = "Send notifications for AWS IAM access key create, update, and delete events using a pipeline for each type of event."
  documentation = file("./README.md")
  categories    = ["public cloud", "security", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
