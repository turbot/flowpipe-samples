mod "lookup_iocs" {
  title       = "Lookup IOCs in different tools"
  description = "A composite Flowpipe mod that lookup IOCS in VirusTotal, Urlscan and other tools."
  categories  = ["security"]

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "v0.0.1-rc.5"
    }
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
