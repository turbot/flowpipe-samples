mod "generate_and_version_sbom" {
  title = "Generate and version SBOM"
  description = "Use AWS Inspector to generate an SBOM of an container and upload the SBOM to a GitHub repository."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.4"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }

    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1-rc.2"
      args = {
        access_token         = "${var.github_access_token}"
        repository_full_name = var.github_repository_full_name
      }
    }
  }

}
