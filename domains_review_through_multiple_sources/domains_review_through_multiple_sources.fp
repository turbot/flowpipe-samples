pipeline "domains_review_through_multiple_sources" {
  title       = "Analyze Domains Through Multiple Sources"
  description = "A composite Flowpipe mod that analyze domain from VirusTotal, Urlscan and other tools"

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
  step "http" "urlhaus_domain_scan" {
    method = "post"
    url    = "https://urlhaus-api.abuse.ch/v1/host"

    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
    }

    request_body = "host=${param.domain}"
  }

  # VirusTotal
  step "pipeline" "virustotal_domain_scan" {
    pipeline = virustotal.pipeline.get_domain_report
    args = {
      domain = param.domain
    }
  }

  # Urlscan.io
  step "pipeline" "urlscan_domain_scan" {
    pipeline = urlscanio.pipeline.search_scan
    args = {
      query = "domain:${param.domain}"
    }
  }

  # IP2Location.io
  step "pipeline" "ip2location_domain_scan" {
    pipeline = ip2locationio.pipeline.get_whois_info
    args = {
      domain = param.domain
    }
  }

  # APIVoid
  step "http" "apivoid_domain_reputation" {
    method = "get"
    url    = "https://endpoint.apivoid.com/domainbl/v1/pay-as-you-go/?key=${param.apivoid_api_key}&host=${param.domain}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  # dnstwister
  step "http" "dnstwister_get_hex" {
    method = "get"
    url    = "https://dnstwister.report/api/to_hex/${param.domain}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  step "http" "dnstwister_parked_score" {
    method = "get"
    url    = "https://dnstwister.report/api/parked/${step.http.dnstwister_get_hex.response_body.domain_as_hexadecimal}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  output "domains_review" {
    value = {
      urlhaus_domain_scan : step.http.urlhaus_domain_scan.response_body,
      virustotal_domain_scan : step.pipeline.virustotal_domain_scan.output.domain_report.data,
      urlscan_domain_scan : step.pipeline.urlscan_domain_scan.output.search_results,
      apivoid_domain_reputation : step.http.apivoid_domain_reputation.response_body.data,
      domain_age : step.pipeline.ip2location_domain_scan.output.domain.domain_age,
      domain_parked_score : step.http.dnstwister_parked_score.response_body
    }
  }
}