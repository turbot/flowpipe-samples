mod "ip_profiler" {
  title       = "IP Profiler"
  description = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and IP2Location, offering in-depth and actionable intelligence on IP addresses."

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "*"
      args = {
        api_key = var.abuseipdb_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-ip2location" {
      version = "*"
      args = {
        api_key = var.ip2location_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "*"
      args = {
        api_key = var.virustotal_api_key
      }
    }
  }
}
