mod "lookup_iocs" {
  title         = "Lookup IOCs In Different Tools"
  description   = "A composite Flowpipe mod that lookup IOCS in VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories    = ["security"]

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "v1.0.0-rc.1"
    }
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
