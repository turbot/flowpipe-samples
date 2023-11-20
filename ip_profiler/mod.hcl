mod "ip_profiler" {
  title       = "IP Profiler"
  description = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and ReallyFreeGeoIP, offering in-depth and actionable intelligence on IP addresses."

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "v0.0.1-rc.1"
      args = {
        api_key = var.abuseipdb_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "v0.0.1-rc.1"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.0.1-rc.3"
      args = {
        api_key = var.virustotal_api_key
      }
    }
  }
}
