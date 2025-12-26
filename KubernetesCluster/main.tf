resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  agent_pool_profile {
    name       = var.agent_pool_name
    count      = var.agent_pool_count
    vm_size    = var.vm_size
    os_type    = var.os_type
  }
  identity {
    type = "SystemAssigned"
  }
}