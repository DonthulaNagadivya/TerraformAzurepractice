variable "rg_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure location"
}
variable "vnet_name" {
  description = "The name of the vnetname"
  type        = string
}
variable "vnet_cidr" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}
variable "public_subnet_cidrs" {
    type = map(string)
    default = {
        "frontend" = "192.168.0.0/24",
        "backend" = "192.168.1.0/24"
    } 
}
variable "private_subnet_cidr" {
  description = "The address space for the private subnet"
  type        = string
  default     = "192.168.2.0/24"
}
variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "foodstorageaccount"
}
