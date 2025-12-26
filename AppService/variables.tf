variable "name" {
  description = "App Service name"
  type        = string
}

variable "location" {
  description = "App Service location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "app_service_plan_id" {
  description = "ID of the App Service Plan"
  type        = string
}

variable "https_only" {
  description = "Enable HTTPS only"
  type        = bool
}