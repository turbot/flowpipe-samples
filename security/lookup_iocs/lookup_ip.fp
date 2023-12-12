pipeline "lookup_ip" {
  title       = "Lookup IP in Different Tools"
  description = "A composite Flowpipe mod that lookup an IP in VirusTotal, Urlscan and other tools."

  param "ip_address" {
    type        = string
    description = "The IP address to be scanned."
  }

  param "max_age_in_days" {
    type        = number
    default     = 30
    optional    = true
    description = "Maximum age in days for the AbuseIPDB reports to retrieve. Defaults to 30 days."
  }

  # AbuseIPDB
  step "pipeline" "abuseipdb_ip_info" {
    pipeline = abuseipdb.pipeline.check_ip_address
    args = {
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "abuseipdb_reports" {
    pipeline = abuseipdb.pipeline.list_ip_address_reports
    args = {
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  # IP2Location.io
  step "pipeline" "ip2location_ip_lookup" {
    pipeline = ip2locationio.pipeline.get_ip_info
    args = {
      ip_address = param.ip_address
    }
  }

  # Urlscan.io
  step "pipeline" "urlscan_ip_lookup" {
    pipeline = urlscanio.pipeline.search_scan
    args = {
      query = "domain:${param.ip_address}"
    }
  }

  output "lookup_ip" {
    value = {
      ip2location_ip_lookup : step.pipeline.ip2location_ip_lookup.output.ip_address,
      abuseipdb_ip_info : step.pipeline.abuseipdb_ip_info.output.ip_report,
      abuseipdb_abuse_reports : step.pipeline.abuseipdb_reports.output.reports,
      urlscan_ip_lookup : step.pipeline.urlscan_ip_lookup.output.search_results
    }
  }
}