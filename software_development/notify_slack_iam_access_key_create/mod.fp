mod "notify_slack_iam_access_key_create" {
  title         = "Notify Slack for New IAM Access Key Create"
  description   = "Notify a Slack channel when a new IAM access key is created."
  documentation = file("./README.md")
  categories    = ["software development"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.2.0"
    }
  }
}
