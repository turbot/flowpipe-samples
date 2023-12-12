pipeline "lookup_url" {
  title       = "Lookup URL in Different Tools"
  description = "A composite Flowpipe mod that lookup an url in VirusTotal, Urlscan and other tools."

  param "virustotal_cred" {
    type        = string
    description = "Name for VirusTotal credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "apivoid_api_key" {
    type        = string
    default     = var.apivoid_api_key
    description = local.apivoid_api_key_param_description
  }

  param "url" {
    type        = string
    description = "The url to be scanned."
  }

  step "pipeline" "virustotal_url_lookup" {
    pipeline = virustotal.pipeline.get_url_analysis
    args = {
      cred = param.virustotal_cred
      url  = param.url
    }
  }

  step "http" "apivoid_url_reputation" {
    method = "get"
    url    = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=${param.apivoid_api_key}&url=${param.url}"

    request_headers = {
      Content-Type = "application/json"
    }
  }

  output "lookup_url" {
    value = {
      virustotal_url_lookup : step.pipeline.virustotal_url_lookup.output.url_analysis.data,
      apivoid_url_reputation : step.http.apivoid_url_reputation.response_body.data
    }
  }
}