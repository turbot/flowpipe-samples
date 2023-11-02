pipeline "ip_profiler" {
  title       = "IP Profiler"
  description = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and IP2Location, offering in-depth and actionable intelligence on IP addresses."

  param "abuseipdb_api_key" {
    type        = string
    default     = var.abuseipdb_api_key
    description = "API key to authenticate requests with AbuseIPDB."
  }

  param "ip2location_api_key" {
    type        = string
    default     = var.ip2location_api_key
    description = "API key to authenticate requests with IP2Location."
  }

  param "virustotal_api_key" {
    type        = string
    default     = var.virustotal_api_key
    description = "API key to authenticate requests with VirusTotal."
  }

  param "ip_address" {
    type        = string
    description = "The IP address you want to profile for detailed insights and security information."
  }

  // AbuseIPDB
  step "pipeline" "abuseipdb" {
    pipeline = abuseipdb.pipeline.check_ip
    args = {
      api_key         = param.abuseipdb_api_key
      ip_address      = param.ip_address
      max_age_in_days = 30
    }
  }

  step "pipeline" "abuseipdb_reports" {
    pipeline = abuseipdb.pipeline.list_reports
    args = {
      api_key         = param.abuseipdb_api_key
      ip_address      = param.ip_address
      max_age_in_days = 30
      page            = 1
      per_page        = 25
    }
  }

  // IP2Location
  step "pipeline" "ip2location" {
    pipeline = ip2location.pipeline.get_ip
    args = {
      api_key    = param.ip2location_api_key
      ip_address = param.ip_address
    }
  }

  // VirusTotal
  step "pipeline" "virustotal" {
    // virustotal works only for ipv4
    if       = can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", param.ip_address)) == true
    pipeline = virustotal.pipeline.get_ip
    args = {
      api_key    = param.virustotal_api_key
      ip_address = param.ip_address
    }
  }

  step "echo" "ip_profile" {
    json = {
      ip2location_ip_location : step.pipeline.ip2location.output.ip_details,
      abuseipdb_ip_info : step.pipeline.abuseipdb.output.report.data,
      abuseipdb_abuse_reports : step.pipeline.abuseipdb_reports.output.reports.data,
      virustotal_ip_scan : try({
        last_analysis_stats : step.pipeline.virustotal.output.ip_report.data.attributes.last_analysis_stats,
        total_votes : step.pipeline.virustotal.output.ip_report.data.attributes.total_votes
      }, "Must be a valid IPv4 for VirusTotal scan.")
    }
  }

  output "ip_profile" {
    value = step.echo.ip_profile.json
  }

  # output "abuseipdb_profile" {
  #   description = "AbuseIPDB Report details."
  #   value       = step.pipeline.abuseipdb.output.report
  # }

  # output "ip2location_profile" {
  #   description = "IP2Location_api_key Report details."
  #   value       = step.pipeline.ip2location.output.ip_details
  # }

  # output "virustotal_profile" {
  #   description = "VirusTotal Report details."
  #   value       = can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", param.ip_address)) ? step.pipeline.virustotal.output.ip_report : "Must be a valid IPv4 for VirusTotal scan."
  # }
}


