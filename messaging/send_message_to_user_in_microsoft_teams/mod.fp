mod "send_message_to_user_in_microsoft_teams" {
  title         = "Send Message to Teams User"
  description   = "Send an email to user in Microsoft Teams."
  documentation = file("./README.md")
  categories    = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.18"
    }
  }
}
