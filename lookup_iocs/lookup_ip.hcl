pipeline "lookup_ip" {
  title       = "Lookup IP in Different Tools"
  description = "A composite Flowpipe mod that lookup an IP in VirusTotal, Urlscan and other tools."

  param "abuseipdb_api_key" {
    type        = string
    default     = var.abuseipdb_api_key
    description = local.abuseipdb_api_key_param_description
  }

  param "ip2location_api_key" {
    type        = string
    default     = var.ip2location_api_key
    description = local.ip2location_api_key_param_description
  }

  param "urlscan_api_key" {
    type        = string
    default     = var.urlscan_api_key
    description = local.urlscan_api_key_param_description
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

  param "page" {
    type        = number
    default     = 1
    optional    = true
    description = "The page number of results to retrieve. Defaults to page 1."
  }

  param "per_page" {
    type        = number
    default     = 25
    optional    = true
    description = "The number of reports per page. Defaults to 25 reports per page."
  }

  # AbuseIPDB
  step "pipeline" "abuseipdb_ip_info" {
    pipeline = abuseipdb.pipeline.check_ip
    args = {
      api_key         = param.abuseipdb_api_key
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "abuseipdb_reports" {
    pipeline = abuseipdb.pipeline.list_reports
    args = {
      api_key         = param.abuseipdb_api_key
      ip_address      = param.ip_address
      max_age_in_days = param.max_age_in_days
      page            = param.page
      per_page        = param.per_page
    }
  }

  # IP2Location
  step "pipeline" "ip2location" {
    pipeline = ip2location.pipeline.get_ip
    args = {
      api_key    = param.ip2location_api_key
      ip_address = param.ip_address
    }
  }

  # Urlscan
  step "pipeline" "urlscan" {
    pipeline = urlscan.pipeline.search_scan
    args = {
      api_key    = param.urlscan_api_key
      query_term = "domain:${param.ip_address}"
    }
  }

  step "echo" "lookup_ip" {
    json = {
      ip2location_ip_location : step.pipeline.ip2location.output.ip_details,
      abuseipdb_ip_info : step.pipeline.abuseipdb_ip_info.output.report.data,
      abuseipdb_abuse_reports : step.pipeline.abuseipdb_reports.output.reports.data.results,
      urlscan_ip_scan : step.pipeline.urlscan.output.scan_result

    }
  }

  output "lookup_ip" {
    value = step.echo.lookup_ip.json
  }
}