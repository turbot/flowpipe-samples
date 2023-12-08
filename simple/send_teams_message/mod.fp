mod "send_teams_message" {
  title       = "Send Teams Message"
  description = "Send a new chat message in the specified channel."
  categories  = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.14"
      args = {
        team_id = var.team_id
      }
    }
  }
}
