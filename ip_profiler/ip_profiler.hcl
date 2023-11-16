pipeline "ip_profiler" {
  title       = "IP Profiler"
  description = "A composite Flowpipe mod that aggregates data from VirusTotal, AbuseIPDB, and ReallyFreeGeoIP, offering in-depth and actionable intelligence on IP addresses."

  param "abuseipdb_api_key" {
    type        = string
    default     = var.abuseipdb_api_key
    description = "API key to authenticate requests with AbuseIPDB."
  }

  param "virustotal_api_key" {
    type        = string
    default     = var.virustotal_api_key
    description = "API key to authenticate requests with VirusTotal."
  }

  param "ip_addresses" {
    type        = list(string)
    description = "The IPv4 or IPv6 address to check for reports."
  }

  param "max_age_in_days" {
    type    = number
    default = 30
    description = "Maximum age in days for the AbuseIPDB reports to retrieve. Defaults to 30 days."
  }

  param "page" {
    type    = number
    default = 1
    description = "The page number of results to retrieve. Defaults to page 1."
  }

  param "per_page" {
    type    = number
    default = 25
    description = "The number of reports per page. Defaults to 25 reports per page."
  }

  # Really Free Geo IP
  step "pipeline" "reallyfreegeoip" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    pipeline = reallyfreegeoip.pipeline.check_ip
    args = {
      ip_address = each.value
    }
  }

  # AbuseIPDB
  step "pipeline" "abuseipdb_ip_info" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    pipeline = abuseipdb.pipeline.check_ip
    args = {
      api_key         = param.abuseipdb_api_key
      ip_address      = each.value
      max_age_in_days = param.max_age_in_days
    }
  }

  step "pipeline" "abuseipdb_reports" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    pipeline = abuseipdb.pipeline.list_reports
    args = {
      api_key         = param.abuseipdb_api_key
      ip_address      = each.value
      max_age_in_days = param.max_age_in_days
      page            = param.page
      per_page        = param.per_page
    }
  }

  # VirusTotal
  step "pipeline" "virustotal" {
    # virustotal works only for ipv4
    for_each = { for ip in param.ip_addresses : ip => ip }
    if       = can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", each.value)) == true
    pipeline = virustotal.pipeline.get_ip_address
    args = {
      api_key    = param.virustotal_api_key
      ip_address = each.value
    }
  }

  step "echo" "ip_profile" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    json = {
      reallyfreegeoip_ip_location : step.pipeline.reallyfreegeoip[each.value].output.report,
      abuseipdb_ip_info : step.pipeline.abuseipdb_ip_info[each.value].output.report.data,
      abuseipdb_abuse_reports : step.pipeline.abuseipdb_reports[each.value].output.reports.data.results,
      virustotal_ip_scan : try(step.pipeline.virustotal[each.value].output.ip_report.data, "Must be a valid IPv4 for VirusTotal scan.")
    }
  }

  output "ip_profile" {
    value = { for ip, details in step.echo.ip_profile : ip => details.json }
  }
}
