mod "send_top_show_hn_email" {
  title       = "Send top 'Show HN' Email"
  description = "Send an email using SendGrid containing top stories from 'Show HN'."

  require {
    mod "github.com/turbot/flowpipe-mod-googleworkspace" {
      version = "0.0.1-rc.1"
      args = {
        code          = var.code
        client_id     = var.client_id
        client_secret = var.client_secret
        access_token  = var.access_token
      }
    }
  }
}
