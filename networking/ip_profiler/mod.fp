mod "ip_profiler" {
  title         = "IP Profiler"
  description   = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and ReallyFreeGeoIP, offering in-depth and actionable intelligence on IP addresses."
  documentation = file("./README.md")
  categories    = ["networking"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "^1"
    }
  }
}
