mod "ip_profiler" {
  title       = "IP Profiler"
  description = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and ReallyFreeGeoIP, offering in-depth and actionable intelligence on IP addresses."
  categories  = ["networking"]

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "v0.0.1-rc.5"
    }
    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "v0.0.1-rc.5"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.0.1-rc.7"
    }
  }
}