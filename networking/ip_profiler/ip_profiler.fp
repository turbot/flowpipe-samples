pipeline "ip_profiler" {
  title       = "IP Profiler"
  description = "Get valuable information about an IP address by combining data from AbuseIPDB, ReallyFreeGeoIP and VirusTotal."

  tags = {
    recommended = "true"
  }

  param "abuseipdb_conn" {
    type        = connection.abuseipdb
    description = "Name of AbuseIPDB connection to use. If not provided, the default AbuseIPDB connection will be used."
    default     = connection.abuseipdb.default
  }

  param "virustotal_conn" {
    type        = connection.virustotal
    description = "Name for connections to use. If not provided, the default connection will be used."
    default     = connection.virustotal.default
  }

  param "ip_addresses" {
    type        = list(string)
    description = "The IPv4 or IPv6 address to check for reports."
  }

  param "abuseipdb_max_age_in_days" {
    type        = number
    default     = 30
    description = "Maximum age in days for the AbuseIPDB reports to retrieve. Defaults to 30 days."
  }

  # ReallyFreeGeoIP - Get IP Geolocation
  step "pipeline" "reallyfreegeoip_ip_geolocation" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    pipeline = reallyfreegeoip.pipeline.get_ip_geolocation
    args = {
      ip_address = each.value
    }
  }

  # AbuseIPDB - Check IP Address
  step "pipeline" "abuseipdb_ip_report" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    pipeline = abuseipdb.pipeline.check_ip_address
    args = {
      conn            = param.abuseipdb_conn
      ip_address      = each.value
      max_age_in_days = param.abuseipdb_max_age_in_days
    }
  }

  # AbuseIPDB - List IP Address Reports
  step "pipeline" "abuseipdb_ip_abuse_reports" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    pipeline = abuseipdb.pipeline.list_ip_address_reports
    args = {
      conn            = param.abuseipdb_conn
      ip_address      = each.value
      max_age_in_days = param.abuseipdb_max_age_in_days
    }
  }

  # VirusTotal - Get IP Address Report
  step "pipeline" "virustotal_get_ip_address_report" {
    # Virustotal works only for IPv4
    for_each = { for ip in param.ip_addresses : ip => ip }
    if       = can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", each.value)) == true
    pipeline = virustotal.pipeline.get_ip_address_report
    args = {
      conn       = param.virustotal_conn
      ip_address = each.value
    }
  }

  step "transform" "ip_profile" {
    for_each = { for ip in param.ip_addresses : ip => ip }
    value = {
      reallyfreegeoip_ip_geolocation : step.pipeline.reallyfreegeoip_ip_geolocation[each.value].output.geolocation,
      abuseipdb_ip_report : step.pipeline.abuseipdb_ip_report[each.value].output.ip_report,
      abuseipdb_ip_abuse_reports : step.pipeline.abuseipdb_ip_abuse_reports[each.value].output.reports,
      virustotal_ip_scan : try(step.pipeline.virustotal_get_ip_address_report[each.value].output.ip_report.data, "Must be a valid IPv4 for VirusTotal scan.")
    }
  }

  output "ip_profile" {
    description = "IP Profile."
    value       = { for ip, details in step.transform.ip_profile : ip => details.value }
  }
}
