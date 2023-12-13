pipeline "lookup_domain" {
  title       = "Lookup Domain in Different Tools"
  description = "A composite Flowpipe mod that lookup a domain in VirusTotal, Urlscan and other tools."

  param "domain" {
    type        = string
    description = "The domain to be scanned."
  }

  # URLhaus
  step "http" "urlhaus_domain_lookup" {
    method = "post"
    url    = "https://urlhaus-api.abuse.ch/v1/host"

    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
    }

    request_body = "host=${param.domain}"
  }

  # VirusTotal
  step "pipeline" "virustotal_domain_lookup" {
    pipeline = virustotal.pipeline.get_domain_report
    args = {
      domain = param.domain
    }
  }

  # Urlscan.io
  step "pipeline" "urlscan_domain_lookup" {
    pipeline = urlscanio.pipeline.search_scan
    args = {
      query = "domain:${param.domain}"
    }
  }

  # Pulsedive
  step "http" "pulsedive_domain_lookup" {
    method = "post"
    url    = "https://pulsedive.com/api/explore.php?q=${param.domain}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  output "lookup_domain" {
    value = {
      urlhaus_domain_lookup : step.http.urlhaus_domain_lookup.response_body,
      virustotal_domain_lookup : step.pipeline.virustotal_domain_lookup.output.domain_report.data,
      pulsedive_domain_lookup : step.http.pulsedive_domain_lookup.response_body,
      urlscan_domain_lookup : step.pipeline.urlscan_domain_lookup.output.search_results
    }
  }
}