pipeline "lookup_domain" {
  title       = "Lookup Domain In Different Tools"
  description = "A composite Flowpipe mod that lookup a domain in VirusTotal, Urlscan and other tools."

  param "virustotal_cred" {
    type        = string
    description = "Name for VirusTotal credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "urlscanio_cred" {
    type        = string
    description = "Name for  URLScan.io credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "domain" {
    type        = string
    description = "The domain to be scanned."
  }

  step "http" "urlhaus_domain_lookup" {
    method = "post"
    url    = "https://urlhaus-api.abuse.ch/v1/host"

    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
    }

    request_body = "host=${param.domain}"
  }

  step "pipeline" "virustotal_domain_lookup" {
    pipeline = virustotal.pipeline.get_domain_report
    args = {
      cred   = param.virustotal_cred
      domain = param.domain
    }
  }

  step "pipeline" "urlscan_domain_lookup" {
    pipeline = urlscanio.pipeline.search_scan
    args = {
      cred   = param.urlscanio_cred
      query = "domain:${param.domain}"
    }
  }

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