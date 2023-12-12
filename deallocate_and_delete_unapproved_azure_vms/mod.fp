mod "deallocate_and_delete_unapproved_azure_vms" {
  title         = "Deallocate And Delete Unapproved Azure VMs"
  description   = "Deallocate and delete unapproved Azure virtual machines and raise Zendesk tickets for the deleted VMs."
  documentation = file("./README.md")
  categories    = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-azure" {
      version = "v0.0.1-rc.11"
      args = {
        subscription_id = var.subscription_id
        resource_group  = var.resource_group
      }
    }
    mod "github.com/turbot/flowpipe-mod-zendesk" {
      version = "v0.0.1-rc.6"
    }
  }
}
