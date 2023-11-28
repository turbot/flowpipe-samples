pipeline "generate_and_version_sbom" {
  title = "Generate and version SBOM"
  description = "Use AWS Inspector to generate an SBOM of an container and upload the SBOM to a GitHub repository."

  param "filter_criteria" {
    type        = string
    description = "Filter criteria for generating the findings report."
    optional    = true
  }

  param "report_format" {
    type        = string
    description = "The format for the findings report. e.g., PDF, CSV, JSON, etc."
  }

  param "s3_destination" {
    type        = string
    description = "The S3 bucket and path where the findings report will be saved."
  }

  step "pipeline" "create_findings_report" {
    pipeline = aws.pipeline.create_findings_report
    args = {
      filter_criteria = param.filter_criteria
      report_format = param.report_format
      s3_destination = param.s3_destination
    }
  }

  step "pipeline" "get_findings_report_status" {
    pipeline = aws.pipeline.get_findings_report_status
    args = {
      report_id = step.pipeline.create_findings_report.output.stdout
    }
  }

  output "create_findings_report_output" {
    description = "The report creation output."
    value       = step.pipeline.create_findings_report.output.stdout
  }

  output "get_findings_report_status_output" {
    description = "The report status output."
    value       = step.pipeline.get_findings_report_status.output.stdout
  }

  // Implement retries until the report is ready

}
