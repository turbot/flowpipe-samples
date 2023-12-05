// When user is deactivated the status is changed to DEPROVISIONED
pipeline "suspend_okta_user" {
  title       = "Suspend Okta User"
  description = "Deletes a user permanently. This operation can only be performed on users that have a DEPROVISIONED status. This action cannot be recovered."

  param "api_token" {
    type        = string
    description = "The Okta personal access api_token to authenticate to the okta APIs."
    default     = var.api_token
  }

  param "domain" {
    type        = string
    description = "The URL of the Okta domain."
    default     = var.okta_domain
  }

  param "user_id" {
    description = "The ID of an user."
    type        = string
  }

  step "pipeline" "suspend_okta_user" {
    pipeline = okta.pipeline.suspend_user
    args = {
      api_token = param.api_token
      user_id   = param.user_id
    }
  }

}
