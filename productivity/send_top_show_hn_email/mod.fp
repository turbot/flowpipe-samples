mod "send_top_show_hn_email" {
  title         = "Send Top 'Show HN' Email"
  description   = "Send an email using SendGrid containing top stories from 'Show HN'."
  documentation = file("./README.md")
  categories    = ["productivity"]

  require {
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "0.1.0"
    }
  }
}
