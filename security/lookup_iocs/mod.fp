mod "lookup_iocs" {
  title         = "Lookup IOCs In Different Tools"
  description   = "A composite Flowpipe mod that lookup IOCS in VirusTotal, Urlscan and other tools."
  documentation = file("./README.md")
  categories    = ["security"]

  opengraph {
    title       = "Lookup IOCs In Different Tools"
    description = "A composite Flowpipe mod that lookup IOCS in VirusTotal, Urlscan and other tools."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-abuseipdb" {
      version = "v0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.2.0"
    }
    mod "github.com/turbot/flowpipe-mod-urlscan" {
      version = "v0.3.0"
    }
    mod "github.com/turbot/flowpipe-mod-ip2locationio" {
      version = "v0.1.0"
    }
  }
}
