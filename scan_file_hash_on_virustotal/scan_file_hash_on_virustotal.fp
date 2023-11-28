pipeline "scan_file_hash_on_virustotal" {
  title = "Scan File Hash on VirusTotal"
  description = "Scans a file hash on VirusTotal."

  param "virustotal_api_key" {
    type        = string
    description = "The VirusTotal API key to use."
    default     = var.virustotal_api_key
  }

  param "file_hash" {
    type        = string
    description = "The hash of the file to get the behaviour summary for."
  }

  step "pipeline" "get_file_analysis" {
    pipeline = virustotal.pipeline.get_file_analysis
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_behaviour_summary" {
    pipeline = virustotal.pipeline.get_file_behaviour_summary
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_behaviours" {
    pipeline = virustotal.pipeline.get_file_behaviours
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_behaviour_mitre_trees" {
    pipeline = virustotal.pipeline.get_file_behaviour_mitre_trees
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_comments" {
    pipeline = virustotal.pipeline.get_file_comments
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_collections" {
    pipeline = virustotal.pipeline.get_file_collections
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_execution_parents" {
    pipeline = virustotal.pipeline.get_file_execution_parents
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_pe_resource_children" {
    pipeline = virustotal.pipeline.get_file_pe_resource_children
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_pe_resource_parents" {
    pipeline = virustotal.pipeline.get_file_pe_resource_parents
    args = {
      api_key   = param.virustotal_api_key
      file_hash = param.file_hash
    }
  }

  output "file_analysis" {
    value = step.pipeline.get_file_analysis.output.file_analysis
  }

  output "behaviour_summary" {
    value = step.pipeline.get_file_behaviour_summary.output.behaviour_summary
  }

  output "behaviours" {
    value = step.pipeline.get_file_behaviours.output.behaviours
  }

  output "behaviour_mitre_trees" {
    value = step.pipeline.get_file_behaviour_mitre_trees.output.behaviour_mitre_trees
  }

  output "comments" {
    value = step.pipeline.get_file_comments.output.comments
  }

  output "file_collections" {
    value = step.pipeline.get_file_comments.output.file_collections
  }

  output "file_execution_parents" {
    value = step.pipeline.get_file_comments.output.file_execution_parents
  }

  output "file_pe_resource_children" {
    value = step.pipeline.get_file_comments.output.file_pe_resource_children
  }

  output "file_pe_resource_parents" {
    value = step.pipeline.get_file_comments.output.file_pe_resource_parents
  }

}
