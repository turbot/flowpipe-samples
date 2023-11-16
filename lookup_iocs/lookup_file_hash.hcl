pipeline "lookup_file_hash" {
  title       = "Lookup File hash in Different Tools"
  description = "A composite Flowpipe mod that lookup a file hash in VirusTotal, Urlscan and other tools."

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

  param "hybrid_analysis_api_key" {
    type        = string
    default     = var.hybrid_analysis_api_key
    description = local.hybrid_analysis_api_key_param_description
  }

  param "file_hash" {
    type        = string
    description = "The file hash to be scanned."
  }

  # VirusTotal
  step "pipeline" "virustotal" {
    pipeline = virustotal.pipeline.get_file_analysis
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  # Urlscan
  step "pipeline" "urlscan" {
    pipeline = urlscan.pipeline.search_scan
    args = {
      api_key    = param.urlscan_api_key
      query_term = "hash:${param.file_hash}"
    }
  }

  # Hybrid Analysis
  step "http" "hybrid" {
    method = "post"
    url    = "https://www.hybrid-analysis.com/api/v2/search/hash"

    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
      api-key      = param.hybrid_analysis_api_key
    }

    request_body = "hash=${param.file_hash}"
  }

  step "echo" "lookup_file_hash" {
    json = {
      virustotal_file_scan : step.pipeline.virustotal.output.file_analysis.data,
      urlscan_file_scan : step.pipeline.urlscan.output.scan_result,
      hybrid_file_scan : step.http.hybrid.response_body
    }
  }

  output "lookup_file_hash" {
    value = step.echo.lookup_file_hash.json
  }
}