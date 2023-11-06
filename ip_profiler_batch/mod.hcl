mod "ip_profiler_batch" {
  title       = "IP Profiler Batch"
  description = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and IP2Location, offering in-depth and actionable intelligence on IP addresses."

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "*"
      args = {
        api_key = var.abuseipdb_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "*"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "*"
      args = {
        api_key = var.virustotal_api_key
      }
    }
  }
}
