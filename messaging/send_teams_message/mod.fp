mod "send_teams_message" {
  title         = "Send Teams Message"
  description   = "Send a new chat message in the specified channel."
  documentation = file("./README.md")
  categories    = ["messaging", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "^1"
    }
  }
}
