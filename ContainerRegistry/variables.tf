variable "name" {
  description = "Container registry name"
  type        = string
}

variable "location" {
  description = "Container registry location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "sku" {
  description = "SKU for the container registry"
  type        = string
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
}