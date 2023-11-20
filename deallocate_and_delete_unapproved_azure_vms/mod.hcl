mod "deallocate_and_delete_unapproved_azure_vms" {
  title       = "Deallocate And Delete Unapproved Azure VMs"
  description = "Deallocate and delete unapproved Azure virtual machines and raise Zendesk tickets for the deleted VMs."

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
    mod "github.com/turbot/flowpipe-mod-zendesk" {
      version = "v0.0.1-rc.1"
      args = {
        api_token  = var.api_token
        user_email = var.user_email
        subdomain  = var.subdomain
      }
    }
  }
}
