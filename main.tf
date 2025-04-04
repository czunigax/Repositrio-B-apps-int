# main.tf
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Grupo de Recursos
resource "azurerm_resource_group" "rgproyecto" {
  name     = "rgp-${var.name_Project}-${var.enviroment}-proyecto"
  location = var.location
  tags     = var.tags
}

# Red Virtual (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name_Project}-${var.enviroment}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rgproyecto.name
  tags                = var.tags
}

# Subred para el Application Gateway
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "snet-appgw-${var.name_Project}-${var.enviroment}"
  resource_group_name  = azurerm_resource_group.rgproyecto.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}