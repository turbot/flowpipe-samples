mod "throw_error_example_using_slack" {
  title         = "Throw Error Example Using Slack"
  description   = "Throw an error if the requested Slack channel is unavailable."
  documentation = file("./README.md")
  categories    = ["messaging", "sample"]

  require {
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.3.0-rc.2"
    }
  }
}
