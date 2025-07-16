provider "azurerm" {
  features { }
  subscription_id = "4c4a9b0e-3bf8-4ea2-a4d2-2fa272a13539"
}
data "azurerm_resource_group" "rg" {
  name = "RG2"
}
resource "azurerm_virtual_network" "Vnet" {
name = "vnet1"
resource_group_name = data.azurerm_resource_group.rg.name
location = data.azurerm_resource_group.rg.location
address_space = ["192.168.0.0/16"]
}