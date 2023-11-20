mod "send_message_to_user_in_microsoft_teams" {
  title       = "Send mail to user"
  description = "Send a message to specific Teams user."

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.3"
      args = {
        access_token = var.access_token
      }
    }
  }
}