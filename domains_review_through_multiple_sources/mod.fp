mod "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools"

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "*"
      args = {
        api_key = var.virustotal_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "*"
      args = {
        api_key = var.urlscan_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-ip2location" {
      version = "*"
      args = {
        api_key = var.ip2location_api_key
      }
    }
  }
}
