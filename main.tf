#Resource group
resource "azurerm_resource_group" "food_rg" {
  name     = var.rg_name
  location = var.location
}
# Virtual Network (Equivalent to Vnet)
resource "azurerm_virtual_network" "food_vnet" {
  name = var.vnet_name
  address_space = var.vnet_cidr
  resource_group_name = azurerm_resource_group.food_rg.name
  location = azurerm_resource_group.food_rg.location
}
  #subnet
resource "azurerm_subnet" "public_subnet" {
  for_each = var.public_subnet_cidrs
  name = "${var.vnet_name}-${each.key}-subnet"
  resource_group_name = azurerm_resource_group.food_rg.name             
  virtual_network_name = azurerm_virtual_network.food_vnet.name
  address_prefixes = [each.value] 
}
# Private Subnet (Database)
resource "azurerm_subnet" "food_db_sn" {
  name                 = "${var.vnet_name}-database-subnet"
  resource_group_name  = azurerm_resource_group.food_rg.name
  virtual_network_name = azurerm_virtual_network.food_vnet.name
  address_prefixes     = [var.private_subnet_cidr]
}
# Network Security Group (NSG) dynamically created for each public subnet
resource "azurerm_network_security_group" "food_nsg" {
  for_each = var.public_subnet_cidrs
  name                = "${var.vnet_name}-${each.key}-nsg"
  location            = azurerm_resource_group.food_rg.location
  resource_group_name = azurerm_resource_group.food_rg.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"          
    destination_port_ranges    = ["22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# network security group for DB
resource "azurerm_network_security_group" "food_db_nsg" {
  name                = "${var.vnet_name}-db-nsg"
  location            = azurerm_resource_group.food_rg.location
  resource_group_name = azurerm_resource_group.food_rg.name

  security_rule {
    name                       = "AllowMySQL"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1433"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
}
# Subnet NSG Association for Public Subnets
resource "azurerm_subnet_network_security_group_association" "food_subnet_nsg_association" {
  for_each = var.public_subnet_cidrs
  subnet_id                 = azurerm_subnet.public_subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.food_nsg[each.key].id
}
# Subnet NSG Association for Private Subnet
resource "azurerm_subnet_network_security_group_association" "food_db_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.food_db_sn.id
  network_security_group_id = azurerm_network_security_group.food_db_nsg.id
}

