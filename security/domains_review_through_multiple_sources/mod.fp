mod "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories  = ["sample" ,"security"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "^1"
    }
  }
}
