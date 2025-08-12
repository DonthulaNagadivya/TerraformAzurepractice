# Public IP for VM
resource "azurerm_public_ip" "food_vm_public_ip" {
  name                = "${var.vnet_name}-vm-public-ip"
  location            = azurerm_resource_group.food_rg.location
  resource_group_name = azurerm_resource_group.food_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Network Interface for VM
resource "azurerm_network_interface" "food_vm_nic" {
  name                = "${var.vnet_name}-vm-nic"
  location            = azurerm_resource_group.food_rg.location
  resource_group_name = azurerm_resource_group.food_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet["frontend"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.food_vm_public_ip.id
  }
}
# Virtual Machine
resource "azurerm_linux_virtual_machine" "food_vm" {
    name                = "${var.vnet_name}-vm"
    resource_group_name = azurerm_resource_group.food_rg.name
    location            = azurerm_resource_group.food_rg.location
    size                = "Standard_B2s"
    admin_username      = "azureuser"
    network_interface_ids = [
        azurerm_network_interface.food_vm_nic.id,
    ]
    
    admin_ssh_key {
        username   = "azureuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }
    
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
    }
    # storage account for remote backend
resource "azurerm_storage_account" "food_storage" {
    name                     = var.storage_account_name
    resource_group_name      = azurerm_resource_group.food_rg.name
    location                 = azurerm_resource_group.food_rg.location
    account_tier            = "Standard"
    account_replication_type = "LRS"
    account_kind            = "StorageV2"
    tags = {
        environment = "Backend for Terraform"
        created_by  = "Terraform"
    }
}
# Storage Container for Terraform state
resource "azurerm_storage_container" "food_container" {
    name                  = "tfstate"
    storage_account_id = azurerm_storage_account.food_storage.id
    container_access_type = "private"
}
#backened configuration for remote state
terraform {
  backend "azurerm" {
    resource_group_name  = "food-rg"
    storage_account_name = "foodstorageaccount1234"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
