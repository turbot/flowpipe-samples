pipeline "lookup_file_hash" {
  title       = "Lookup File hash In Different Tools"
  description = "A composite Flowpipe mod that lookup a file hash in VirusTotal, Urlscan and other tools."

  param "virustotal_cred" {
    type        = string
    description = "Name for VirusTotal credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "urlscan_cred" {
    type        = string
    description = "Name for  URLScan.io credentials to use. If not provided, the default credentials will be used."
    default     = "default"
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
      cred      = param.virustotal_cred
      file_hash = param.file_hash
    }
  }

  step "pipeline" "urlscan_file_hash_lookup" {
    pipeline = urlscan.pipeline.search_scan
    args = {
      cred  = param.urlscan_cred
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
