mod "send_top_show_hn_email" {
  title         = "Send Top 'Show HN' Email"
  description   = "Send an email using SendGrid containing top stories from 'Show HN'."
  documentation = file("./README.md")
  categories    = ["productivity", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "^1"
    }
  }
}
