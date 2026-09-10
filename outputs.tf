output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_hub_id" {
  value = azurerm_virtual_network.vnet_hub.id
}

output "vnet_spoke_id" {
  value = azurerm_virtual_network.vnet_spoke.id
}

output "bastion_hostname" {
  value = azurerm_bastion_host.bastion.dns_name
}

output "spoke_vm_private_ip" {
  value = azurerm_network_interface.nic_vm_spoke.private_ip_address
}