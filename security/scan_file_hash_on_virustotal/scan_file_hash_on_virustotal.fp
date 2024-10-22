pipeline "scan_file_hash_on_virustotal" {
  title = "Scan File Hash on VirusTotal"
  description = "Scans a file hash on VirusTotal."

  param "virustotal_conn" {
    type        = connection.virustotal
    description = "Name for VirusTotal connections to use. If not provided, the default connections will be used."
    default     = connection.virustotal.default
  }

  param "file_hash" {
    type        = string
    description = "The hash of the file to get the behaviour summary for."
  }

  step "pipeline" "get_file_analysis" {
    pipeline = virustotal.pipeline.get_file_analysis
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_behaviour_summary" {
    pipeline = virustotal.pipeline.get_file_behaviour_summary
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_behaviours" {
    pipeline = virustotal.pipeline.get_file_behaviours
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_behaviour_mitre_trees" {
    pipeline = virustotal.pipeline.get_file_behaviour_mitre_trees
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_comments" {
    pipeline = virustotal.pipeline.get_file_comments
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_collections" {
    pipeline = virustotal.pipeline.get_file_collections
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_execution_parents" {
    pipeline = virustotal.pipeline.get_file_execution_parents
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_pe_resource_children" {
    pipeline = virustotal.pipeline.get_file_pe_resource_children
    args = {
      conn      = param.virustotal_conn
      file_hash = param.file_hash
    }
  }

  step "pipeline" "get_file_pe_resource_parents" {
    pipeline = virustotal.pipeline.get_file_pe_resource_parents
    args = {
      conn      = param.virustotal_conn
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
    value = step.pipeline.get_file_collections.output.collections
  }

  output "file_execution_parents" {
    value = step.pipeline.get_file_execution_parents.output.execution_parents
  }

  output "file_pe_resource_children" {
    value = step.pipeline.get_file_pe_resource_children.output.pe_resource_children
  }

  output "file_pe_resource_parents" {
    value = step.pipeline.get_file_pe_resource_parents.output.pe_resource_parents
  }

}
