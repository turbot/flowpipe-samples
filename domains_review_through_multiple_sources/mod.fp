mod "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools"

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.0.1-rc.7"
    }
    mod "github.com/turbot/flowpipe-mod-urlscanio" {
      version = "v0.0.1-rc.2"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "v0.0.1-rc.1"
    }
  }
}
