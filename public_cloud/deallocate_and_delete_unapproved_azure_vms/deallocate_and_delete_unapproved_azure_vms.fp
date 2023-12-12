trigger "schedule" "deallocate_and_delete_unapproved_azure_vms" {
  description = "A daily cron job at 9 AM UTC that checks for Azure Unapproved VMs, deallocates and deletes them."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.deallocate_and_delete_unapproved_azure_vms
}

pipeline "deallocate_and_delete_unapproved_azure_vms" {

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
  }

  param "tenant_id" {
    type = string
    # description = local.tenant_id_param_description
    default = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
  }

  param "tags_query" {
    type        = string
    description = "A JMESPath query to use in filtering the response data."
    default     = "[?tags.environment=='development' || tags.environment=='dev'].name"
  }

  param "api_token" {
    type        = string
    description = local.api_token_param_description
    default     = var.api_token
  }

  param "user_email" {
    type        = string
    description = local.user_email_param_description
    default     = var.user_email
  }

  param "subdomain" {
    type        = string
    description = local.subdomain_param_description
    default     = var.subdomain
  }

  # List Azure VMs with the given tags as per the query param.
  step "pipeline" "list_azure_vms" {
    pipeline = azure.pipeline.list_compute_virtual_machines
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      query           = param.tags_query
    }

    # When there are no VMs, exit the pipeline.
    throw {
      if      = result.output.stdout == ""
      message = "There are no VMs matching the desired tags. Exiting the pipeline."
    }
  }

  # For list of VMs with required Tags, get the instance status of each VM.
  step "pipeline" "get_compute_virtual_machine_instance_view" {
    for_each = { for name in step.pipeline.list_azure_vms.output.stdout : name => name }
    pipeline = azure.pipeline.get_compute_virtual_machine_instance_view
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      vm_name         = each.value
      query           = "instanceView.statuses[1]"
    }
  }

  # For list of VMs with required Tags, NOT added to approved list and in running state, then deallocate the VMs.
  step "pipeline" "deallocate_instances" {
    for_each = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_instance_view : vm_name => vm_status.output.stdout
      if vm_status.output.stdout.displayStatus == "VM running" && !contains(local.approved_vm_names, vm_name)
    }
    pipeline = azure.pipeline.deallocate_compute_virtual_machine
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      vm_name         = each.key
    }
  }

  # For list of VMs with required Tags, NOT added to approved list and in deallocated or stopped state, then delete the VMs.
  step "pipeline" "delete_instances" {
    for_each = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_instance_view : vm_name => vm_status.output.stdout
      if(vm_status.output.stdout.displayStatus == "VM deallocated" || vm_status.output.stdout.displayStatus == "VM stopped") && !contains(local.approved_vm_names, vm_name)
    }
    pipeline = azure.pipeline.delete_compute_virtual_machine
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      vm_name         = each.key
    }
  }

  # For list of VMs with required Tags, NOT added to approved list and are deleted, create a Zendesk ticket.
  step "pipeline" "zendesk_create_ticket" {
    for_each = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_instance_view : vm_name => vm_status.output.stdout
      if(vm_status.output.stdout.displayStatus == "VM deallocated" || vm_status.output.stdout.displayStatus == "VM stopped") && !contains(local.approved_vm_names, vm_name)
    }
    depends_on = [step.pipeline.delete_instances]
    pipeline   = zendesk.pipeline.create_ticket
    args = {
      api_token  = param.api_token
      user_email = param.user_email
      subdomain  = param.subdomain
      subject    = "Unapproved Azure VM Deleted"
      comment = ({
        body   = "Unapproved Azure VM Deleted\nSubscriptionId: ${param.subscription_id}\nResourceGroup: ${param.resource_group}\nName: ${each.key}\n",
        public = true
      })
    }
  }

  output "vms_with_tag" {
    description = "List of Azure VMs with the desired tags."
    value       = step.pipeline.list_azure_vms.output.stdout
  }

  output "vm_statuses" {
    description = "List of Azure VMs with their instance status."
    value       = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_instance_view : vm_name => vm_status.output.stdout }
  }

  output "deallocated_vms" {
    description = "List of Azure VMs that are deallocated."
    value       = { for vm_name, vm_deallocation in step.pipeline.deallocate_instances : vm_name => "${vm_name} deallocated" if vm_deallocation.output.stdout == "" }
  }

  output "deleted_vms" {
    description = "List of Azure VMs that are deleted."
    value       = { for vm_name, vm_deletion in step.pipeline.delete_instances : vm_name => "${vm_name} deleted" if vm_deletion.output.stdout == "" }
  }

  output "zendesk_tickets" {
    description = "List of Zendesk tickets created for the deleted VMs."
    value       = { for vm_name, ticket in step.pipeline.zendesk_create_ticket : vm_name => ticket.output.ticket.id }
  }
}
