mod "send_discord_message" {
  title       = "Send Discord Message"
  description = "Send a message to a Discord channel."
  categories = ["messaging"]

  opengraph {
  title       = "Send Discord Message"
  description = "Send a message to a Discord channel."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-discord" {
      version = "0.0.1-rc.4"
    }
  }
}
