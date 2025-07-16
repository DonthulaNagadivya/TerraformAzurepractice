provider "azurerm" {
  features {}
  subscription_id = "4c4a9b0e-3bf8-4ea2-a4d2-2fa272a13539"
}
resource "azurerm_resource_group" "rg" {
  name     = "RG2"
  location = "East US"
}
 terraform import azurerm_resource_group.resourcegroup /subscriptions/subsriptionID/resourceGroups/RG2