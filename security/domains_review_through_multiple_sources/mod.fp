mod "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories  = ["sample" ,"security"]

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v1.0.0-rc.1"
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "v1.0.0-rc.1"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "v1.0.0-rc.1"
    }
  }
}
