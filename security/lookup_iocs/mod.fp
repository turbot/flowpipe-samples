mod "lookup_iocs" {
  title         = "Lookup IOCs In Different Tools"
  description   = "A composite Flowpipe mod that lookup IOCS in VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories    = ["security"]

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "0.1.0"
    }
  }
}
