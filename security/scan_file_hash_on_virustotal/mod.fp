mod "scan_file_hash_on_virustotal" {
  title = "Scan File Hash on VirusTotal"
  description = "Scans a file hash on VirusTotal."

  opengraph {
    title = "Scan File Hash on VirusTotal"
    description = "Scans a file hash on VirusTotal."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "0.1.0"
    }
  }

}
