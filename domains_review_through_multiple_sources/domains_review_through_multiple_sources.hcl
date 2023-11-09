pipeline "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze data from VirusTotal, Urlscan and other tools"

  param "virustotal_api_key" {
    type        = string
    default     = var.virustotal_api_key
    description = "API key to authenticate requests with VirusTotal."
  }

  param "urlscan_api_key" {
    type        = string
    default     = var.urlscan_api_key
    description = "The urlscan.io personal access token to authenticate to the urlscan APIs ."
  }

  param "ip2location_api_key" {
    type        = string
    default     = var.ip2location_api_key
    description = "API key to authenticate requests with IP2Location."
  }

  param "apivoid_api_key" {
    type        = string
    default     = var.apivoid_api_key
    description = "API key to authenticate requests with APIVoid."
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

  # IP2Location
  step "pipeline" "ip2location" {
    pipeline = ip2location.pipeline.get_whois_info
    args = {
      api_key = param.ip2location_api_key
      domain  = param.domain
    }
  }

  # APIVoid
  step "http" "domain_reputation" {
    method = "get"
    url    = "https://endpoint.apivoid.com/domainbl/v1/pay-as-you-go/?key=${param.apivoid_api_key}&host=${param.domain}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  # dnstwister
  step "http" "dnstwister_hex" {
    method = "get"
    url    = "https://dnstwister.report/api/to_hex/${param.domain}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  step "http" "dnstwister_parked_score" {
    method = "get"
    url    = "https://dnstwister.report/api/parked/${step.http.dnstwister_hex.response_body.domain_as_hexadecimal}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  step "echo" "domains_review" {
    json = {
      urlhaus_domain_scan : step.http.urlhaus.response_body,
      virustotal_domain_scan : step.pipeline.virustotal.output.domain_report.data,
      urlscan_domain_scan : step.pipeline.urlscan.output.scan_result
      apivoid_domain_reputation : step.http.domain_reputation.response_body.data
      domain_age : step.pipeline.ip2location.output.whois_info.domain_age,
      domain_parked_score : step.http.dnstwister_parked_score.response_body
    }
  }

  output "domains_review" {
    value = step.echo.domains_review.json
  }
}