pipeline "lookup_ip" {
  title       = "Lookup IP in Different Tools"
  description = "A composite Flowpipe mod that lookup an IP in VirusTotal, Urlscan and other tools."

  param "abuseipdb_cred" {
    type        = string
    description = "Name for AbuseIPDB credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "ip2locationio_cred" {
    type        = string
    description = "Name for IP2Location credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "urlscanio_cred" {
    type        = string
    description = "Name for  URLScan.io credentials to use. If not provided, the default credentials will be used."
    default     = "default"
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
      cred            = param.abuseipdb_cred
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "abuseipdb_reports" {
    pipeline = abuseipdb.pipeline.list_ip_address_reports
    args = {
      cred            = param.abuseipdb_cred
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "ip2location_ip_lookup" {
    pipeline = ip2locationio.pipeline.get_ip_info
    args = {
      cred       = param.ip2locationio_cred
      ip_address = param.ip_address
    }
  }

  step "pipeline" "urlscan_ip_lookup" {
    pipeline = urlscanio.pipeline.search_scan
    args = {
      cred  = param.urlscanio_cred
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