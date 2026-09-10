# 1. Network Security Group (NSG) per isolare la subnet dello Spoke
resource "azurerm_network_security_group" "nsg_spoke" {
  name                = "nsg-spoke-workloads"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_resource_group.rg]

  # Consente SSH (porta 22) solo dall'interno della VNet Hub (incluso Azure Bastion)
  security_rule {
    name                       = "Allow-SSH-From-Hub"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associazione dell'NSG alla Subnet dei carichi di lavoro
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet_workloads.id
  network_security_group_id = azurerm_network_security_group.nsg_spoke.id
}

# 2. Network Interface (NIC) per la VM - SENZA IP pubblico
resource "azurerm_network_interface" "nic_vm_spoke" {
  name                = "nic-vm-spoke"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_workloads.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# 3. Virtual Machine Linux (Ubuntu 22.04 LTS)
resource "azurerm_linux_virtual_machine" "vm_spoke" {
  name                = "vm-spoke-workload"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s" # Taglia economica per lab/test
  admin_username      = "azureuser"
  admin_password      = "P@ssw0rd12345!"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_vm_spoke.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}