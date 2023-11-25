pipeline "create_findings_report" {
  title       = "Create Findings Report"
  description = "Generates a findings report based on specified criteria and saves it to the specified S3 bucket."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

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

  step "container" "create_findings_report" {
    image = "amazon/aws-cli"

    cmd = [
      "securityhub",
      "create-findings-report",
      "--region", "param.region",
      param.filter_criteria != null ? ["--filter-criteria", "param.filter_criteria"] : [],
      "--report-format", "param.report_format",
      "--s3-destination", "param.s3_destination"
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "Details of the generated findings report."
    value       = jsondecode(step.container.create_findings_report.stdout)
  }

  output "stderr" {
    value = step.container.create_findings_report.stderr
  }
}
