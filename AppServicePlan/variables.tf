variable "name" {
  description = "App Service Plan name"
  type        = string
}

variable "location" {
  description = "App Service Plan location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "sku" {
  description = "SKU for the App Service Plan"
  type        = string
}

variable "kind" {
  description = "Kind of the App Service Plan"
  type        = string
}