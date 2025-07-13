provider "azurerm" {
  features {}
  subscription_id = "a2a9f784-eb09-4959-9e93-bd058c5daff1"
}
resource "azurerm_resource_group" "RG" {
  name     = var.RGname
  location = var.location
}
resource "azurerm_virtual_network" "Vnet" {
  name = var.vnetname
  resource_group_name = azurerm_resource_group.RG.name
  location = azurerm_resource_group.RG.location
  address_space = var.address_space
}
resource "azurerm_subnet" "subnet" {
  name = var.subnetname
  resource_group_name = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes = var.address_prefixes
}
resource "azurerm_network_interface" "nic" {
  name = var.nicname
  resource_group_name = azurerm_resource_group.RG.name
  location = azurerm_resource_group.RG.location
  ip_configuration {
    name       = var.ipconfig_name
    subnet_id  = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.ip_allocation
  }
}
resource "azurerm_virtual_machine" "VM" {
  name = var.vmname
  resource_group_name = azurerm_resource_group.RG.name
  location = azurerm_resource_group.RG.location
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  vm_size = var.vm_size
  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.sku
    version   = "latest"
  }
storage_os_disk {
    name   = var.os_disk_name
    caching = "ReadWrite"
    managed_disk_type = var.storage_type
    create_option = "FromImage"
  }
  os_profile {
     computer_name = var.vmname
  admin_username  = var.username
  admin_password   = var.password
  }
os_profile_windows_config {
 

}
}
