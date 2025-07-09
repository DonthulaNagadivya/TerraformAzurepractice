variable "RGname" {
  description = "The name of the resource group"
  type        = string
}
variable "location" {
  description = "The name of the resource group"
  type        = string
}
variable "vnetname" {
  description = "The name of the resource group"
  type        = string
}
variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["192.178.0.0/16"]
}
variable "subnetname" {
  description = "The name of the resource group"
  type        = string
}
variable "address_prefixes" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["192.178.0.0/24"]
}
variable "nicname" {
  description = "The name of the resource group"
  type        = string
}
variable "ipconfig_name" {
  description = "The name of the resource group"
  type        = string
}
variable "ip_allocation" {
  description = "The name of the resource group"
  type        = string
}
variable "vmname" {
  description = "The name of the resource group"
  type        = string
}
variable "vm_size" {
  description = "The name of the resource group"
  type        = string
}
variable "vm_publisher" {
  description = "The name of the resource group"
  type        = string
}
variable "vm_offer" {
  description = "The name of the resource group"
  type        = string
}
variable "sku" {
  description = "The name of the resource group"
  type        = string
}
variable "os_disk_name" {
  description = "The name of the resource group"
  type        = string
}
variable "username" {
  description = "The name of the resource group"
  type        = string
  sensitive   = true
}
variable "password" {
  description = "The name of the resource group"
  type        = string
  sensitive   = true
}
variable "storage_type" {
  description = "The name of the resource group"
  type        = string
}