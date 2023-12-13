mod "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories  = ["security"]

  opengraph {
    title       = "Analyze Domains Through Multiple Sources"
    description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.2.0"
    }
    mod "github.com/turbot/flowpipe-mod-urlscanio" {
      version = "v0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "v0.3.0"
    }
  }
}