pipeline "lookup_iocs" {
  title       = "Lookup IOCs in Different Tools"
  description = "A composite Flowpipe mod that lookup IOCs in VirusTotal, Urlscan and other tools."

  param "virustotal_api_key" {
    type        = string
    default     = var.virustotal_api_key
    description = local.virustotal_api_key_param_description
  }

  param "urlscan_api_key" {
    type        = string
    default     = var.urlscan_api_key
    description = local.urlscan_api_key_param_description
  }

  param "hunter_api_key" {
    type        = string
    default     = var.hunter_api_key
    description = local.hunter_api_key_param_description
  }

  param "kickbox_api_key" {
    type        = string
    default     = var.kickbox_api_key
    description = local.kickbox_api_key_param_description
  }

  param "hybrid_analysis_api_key" {
    type        = string
    default     = var.hybrid_analysis_api_key
    description = local.hybrid_analysis_api_key_param_description
  }

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

  param "apivoid_api_key" {
    type        = string
    default     = var.apivoid_api_key
    description = local.apivoid_api_key_param_description
  }

  param "iocs" {
    type        = list(map)
    description = "The iocs to be scanned."
  }

  # Domain
  step "pipeline" "domain" {
    for_each = { for ioc in param.iocs : ioc.id => ioc if ioc.type == "domain" }
    pipeline = pipeline.lookup_domain
    args = {
      virustotal_api_key = param.virustotal_api_key
      urlscan_api_key    = param.urlscan_api_key
      domain             = each.value.value
    }
  }

  # Email
  step "pipeline" "email" {
    for_each = { for ioc in param.iocs : ioc.id => ioc if ioc.type == "email" }
    pipeline = pipeline.lookup_email
    args = {
      hunter_api_key  = param.hunter_api_key
      kickbox_api_key = param.kickbox_api_key
      email           = each.value.value
    }
  }

  # File hash
  step "pipeline" "file_hash" {
    for_each = { for ioc in param.iocs : ioc.id => ioc if ioc.type == "file_hash" }
    pipeline = pipeline.lookup_file_hash
    args = {
      virustotal_api_key      = param.virustotal_api_key
      urlscan_api_key         = param.urlscan_api_key
      hybrid_analysis_api_key = param.hybrid_analysis_api_key
      file_hash               = each.value.value
    }
  }

  # IP
  step "pipeline" "ip" {
    for_each = { for ioc in param.iocs : ioc.id => ioc if ioc.type == "ip" }
    pipeline = pipeline.lookup_ip
    args = {
      ip2location_api_key = param.ip2location_api_key
      urlscan_api_key     = param.urlscan_api_key
      abuseipdb_api_key   = param.abuseipdb_api_key
      ip_address          = each.value.value
    }
  }

  # URL
  step "pipeline" "url" {
    for_each = { for ioc in param.iocs : ioc.id => ioc if ioc.type == "url" }
    pipeline = pipeline.lookup_url
    args = {
      virustotal_api_key = param.virustotal_api_key
      apivoid_api_key    = param.apivoid_api_key
      url                = each.value.value
    }
  }

  step "echo" "lookup_iocs" {
    json = {
      domain_scan : step.pipeline.domain.output,
      email_scan : step.pipeline.email.output,
      file_hash_scan : step.pipeline.file_hash.output,
      ip_scan : step.pipeline.ip.output,
      url_scan : step.pipeline.url.output
    }
  }

  output "lookup_iocs" {
    value = step.echo.lookup_iocs.json
  }
}