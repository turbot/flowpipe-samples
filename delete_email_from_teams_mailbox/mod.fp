mod "delete_email_from_teams_mailbox" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools"

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.7"
      args = {
        access_token = var.teams_access_token
      }
    }
  }
}
