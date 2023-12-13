mod "send_teams_message" {
  title         = "Send Teams Message"
  description   = "Send a new chat message in the specified channel."
  documentation = file("./README.md")
  categories    = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "0.1.0"
    }
  }
}
