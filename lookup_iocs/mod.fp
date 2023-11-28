mod "lookup_iocs" {
  title       = "Lookup IOCs in different tools"
  description = "A composite Flowpipe mod that lookup IOCS in VirusTotal, Urlscan and other tools"

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "v0.0.1-rc.1"
      args = {
        api_key = var.abuseipdb_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.0.1-rc.2"
      args = {
        api_key = var.virustotal_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "v0.0.1-rc.1"
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
