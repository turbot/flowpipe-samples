pipeline "lookup_domain" {
  title       = "Lookup Domain in Different Tools"
  description = "A composite Flowpipe mod that lookup a domain in VirusTotal, Urlscan and other tools."

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

  param "domain" {
    type        = string
    description = "The domain to be scanned."
  }

  # URLhaus
  step "http" "urlhaus" {
    method = "post"
    url    = "https://urlhaus-api.abuse.ch/v1/host"

    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
    }

    request_body = "host=${param.domain}"
  }

  # VirusTotal
  step "pipeline" "virustotal" {
    pipeline = virustotal.pipeline.get_domain
    args = {
      api_key = param.virustotal_api_key
      domain  = param.domain
    }
  }

  # Urlscan
  step "pipeline" "urlscan" {
    pipeline = urlscan.pipeline.search_scan
    args = {
      api_key    = param.urlscan_api_key
      query_term = "domain:${param.domain}"
    }
  }

  # Pulsedive
  step "http" "pulsedive" {
    method = "post"
    url    = "https://pulsedive.com/api/explore.php?q=${param.domain}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  step "echo" "lookup_domain" {
    json = {
      urlhaus_domain_scan : step.http.urlhaus.response_body,
      virustotal_domain_scan : step.pipeline.virustotal.output.domain_report.data,
      pulsedive_domain_scan : step.http.pulsedive.response_body,
      urlscan_domain_scan : step.pipeline.urlscan.output.scan_result
    }
  }

  output "lookup_domain" {
    value = step.echo.lookup_domain.json
  }
}