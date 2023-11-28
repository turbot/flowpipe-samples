mod "send_top_show_hn_email" {
  title       = "Send top 'Show HN' Email"
  description = "Send an email using SendGrid containing top stories from 'Show HN'."

  require {
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "0.0.1-rc.1"
      args = {
        api_key = var.sendgrid_api_key
      }
    }
  }
}
