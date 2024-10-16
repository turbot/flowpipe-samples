mod "scan_file_hash_on_virustotal" {
  title         = "Scan File Hash on VirusTotal"
  description   = "Scans a file hash on VirusTotal."
  documentation = file("./README.md")
  categories    = ["security"]

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v1.0.0-rc.1"
    }
  }

}
