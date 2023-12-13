mod "throw_error_example_using_slack" {
  title       = "Throw Error Example Using Slack"
  description = "Throw an error if the requested Slack channel is unavailable."
  categories  = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.0.1-rc.6"
    }
  }
}
