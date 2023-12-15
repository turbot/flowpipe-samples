mod "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories  = ["security"]

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "0.1.0"
    }
  }
}
