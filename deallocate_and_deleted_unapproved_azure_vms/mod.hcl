mod "deallocate_and_deleted_unapproved_azure_vms" {
  title       = "Jira integration for Azure AD users"
  description = " TO DO."

  require {
    mod "github.com/turbot/flowpipe-mod-azure" {
      version = "v0.0.1-rc.2"
      args = {
        subscription_id = var.subscription_id
        tenant_id       = var.tenant_id
        client_secret   = var.client_secret
        client_id       = var.client_id
        resource_group  = var.resource_group
      }
    }
  }
}
