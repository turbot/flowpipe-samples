pipeline "lookup_file_hash" {
  title       = "Lookup File hash in Different Tools"
  description = "A composite Flowpipe mod that lookup a file hash in VirusTotal, Urlscan and other tools."

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
  step "pipeline" "virustotal_file_hash_lookup" {
    pipeline = virustotal.pipeline.get_file_analysis
    args = {
      file_hash = param.file_hash
    }
  }

  # Urlscan.io
  step "pipeline" "urlscan_file_hash_lookup" {
    pipeline = urlscanio.pipeline.search_scan
    args = {
      query = "hash:${param.file_hash}"
    }
  }

  # Hybrid Analysis
  step "http" "hybrid_analysis_file_hash_lookup" {
    method = "post"
    url    = "https://www.hybrid-analysis.com/api/v2/search/hash"

    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
      api-key      = param.hybrid_analysis_api_key
    }

    request_body = "hash=${param.file_hash}"
  }

  output "lookup_file_hash" {
    value = {
      virustotal_file_hash_lookup : step.pipeline.virustotal_file_hash_lookup.output.file_analysis.data,
      urlscan_file_hash_lookup : step.pipeline.urlscan_file_hash_lookup.output.search_results,
      hybrid_analysis_file_hash_lookup : step.http.hybrid_analysis_file_hash_lookup.response_body
    }
  }
}
