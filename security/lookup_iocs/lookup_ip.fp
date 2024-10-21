pipeline "lookup_ip" {
  title       = "Lookup IP In Different Tools"
  description = "A composite Flowpipe mod that lookup an IP in VirusTotal, Urlscan and other tools."

  param "abuseipdb_conn" {
    type        = connection.abuseipdb
    description = "Name of AbuseIPDB connection to use. If not provided, the default AbuseIPDB connection will be used."
    default     = connection.abuseipdb.default
  }

  param "ip2locationio_conn" {
    type        = connection.ip2locationio
    description = "Name of IP2Locationio connection to use. If not provided, the default IP2Locationio connection will be used."
    default     = connection.ip2locationio.default
  }

  param "urlscan_conn" {
    type        = connection.urlscan
    description = "Name of URL Scan connection to use. If not provided, the default URL Scan connection will be used."
    default = connection.urlscan.default
  }

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

  step "pipeline" "abuseipdb_ip_info" {
    pipeline = abuseipdb.pipeline.check_ip_address
    args = {
      conn            = param.abuseipdb_conn
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "abuseipdb_reports" {
    pipeline = abuseipdb.pipeline.list_ip_address_reports
    args = {
      conn            = param.abuseipdb_conn
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "ip2locationio_ip_lookup" {
    pipeline = ip2locationio.pipeline.get_ip_info
    args = {
      conn       = param.ip2locationio_conn
      ip_address = param.ip_address
    }
  }

  step "pipeline" "urlscan_ip_lookup" {
    pipeline = urlscan.pipeline.search_scan
    args = {
      conn  = param.urlscan_conn
      query = "domain:${param.ip_address}"
    }
  }

  output "lookup_ip" {
    value = {
      ip2locationio_ip_lookup : step.pipeline.ip2locationio_ip_lookup.output.ip_address,
      abuseipdb_ip_info : step.pipeline.abuseipdb_ip_info.output.ip_report,
      abuseipdb_abuse_reports : step.pipeline.abuseipdb_reports.output.reports,
      urlscan_ip_lookup : step.pipeline.urlscan_ip_lookup.output.search_results
    }
  }
}
