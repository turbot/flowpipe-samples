mod "scan_file_hash_on_virustotal" {
  title = "Scan File Hash on VirusTotal"
  description = "Scans a file hash on VirusTotal."

  require {
    mod "github.com/turbot/flowpipe-mod-virustotal" {
      version = "v0.0.3-rc.1"
      args = {
        api_key = var.virustotal_api_key
      }
    }
  }

}
