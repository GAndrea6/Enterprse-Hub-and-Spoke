# 1. IP Pubblico Statico per Azure Bastion (richiede SKU Standard)
resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# 2. Azure Bastion Host nell'Hub
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-hub"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }

  tags = var.tags
}