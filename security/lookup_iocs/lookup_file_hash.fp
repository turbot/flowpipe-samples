pipeline "lookup_file_hash" {
  title       = "Lookup File hash In Different Tools"
  description = "A composite Flowpipe mod that lookup a file hash in VirusTotal, Urlscan and other tools."

  param "virustotal_conn" {
    type        = connection.virustotal
    description = "Name of VirusTotal connection to use. If not provided, the default VirusTotal connection will be used."
    default     = connection.virustotal.default
  }

  param "urlscan_conn" {
    type        = connection.urlscan
    description = "Name of URL Scan connection to use. If not provided, the default URL Scan connection will be used."
    default = connection.urlscan.default
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

  step "pipeline" "virustotal_file_hash_lookup" {
    pipeline = virustotal.pipeline.get_file_analysis
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "urlscan_file_hash_lookup" {
    pipeline = urlscan.pipeline.search_scan
    args = {
      conn  = param.urlscan_conn
      query = "hash:${param.file_hash}"
    }
  }

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
