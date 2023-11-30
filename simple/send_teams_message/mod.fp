mod "send_teams_message" {
  title       = "Send Teams Message"
  description = "Send a new chat message in the specified channel."

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.10"
      args = {
        access_token = var.access_token
        team_id = var.team_id
      }
    }
  }
}
