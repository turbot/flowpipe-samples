mod "send_discord_message" {
  title         = "Send Discord Message"
  description   = "Send a message to a Discord channel."
  documentation = file("./README.md")
  categories    = ["messaging"]

  require {
    mod "github.com/turbot/flowpipe-mod-discord" {
      version = "1.0.0-rc-1.1"
    }
  }
}
