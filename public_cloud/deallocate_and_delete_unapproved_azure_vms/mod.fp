mod "deallocate_and_delete_unapproved_azure_vms" {
  title         = "Deallocate And Delete Unapproved Azure VMs"
  description   = "Deallocate and delete unapproved Azure virtual machines and raise Zendesk tickets for the deleted VMs."
  documentation = file("./README.md")
  categories    = ["sample", "public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-azure" {
      version = "1.0.0-rc.2"
    }
    mod "github.com/turbot/flowpipe-mod-zendesk" {
      version = "1.0.0-rc.2"
    }
  }
}
