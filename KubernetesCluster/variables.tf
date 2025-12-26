variable "name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "location" {
  description = "Kubernetes cluster location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the Kubernetes cluster"
  type        = string
}

variable "agent_pool_name" {
  description = "Agent pool name"
  type        = string
}

variable "agent_pool_count" {
  description = "Number of agents in the pool"
  type        = number
}

variable "vm_size" {
  description = "VM size for the agents"
  type        = string
}

variable "os_type" {
  description = "Operating system type"
  type        = string
}