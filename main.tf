resource "azurerm_app_service" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = azurerm_app_service_plan.this.id

  auth_settings {
    enabled          = true
    default_provider  = "AzureActiveDirectory"
    issuer           = "https://login.microsoftonline.com/{tenant-id}/v2.0"
    client_id        = var.client_id
    client_secret    = var.client_secret
  }

  client_cert_enabled = true

  site_config {
    detailed_error_messages_enabled = false # Modified to ensure security
    failed_request_tracing_enabled   = true # Ensure failed request tracing is enabled (CKV_AZURE_66)
    ftps_state                       = "Disabled" # Ensure FTP deployments are disabled (CKV_AZURE_78)
    http_logging_enabled              = true # Ensure HTTP logging is enabled (CKV_AZURE_63)
    http_version                     = "2.0" # Ensure HTTP version is the latest (CKV_AZURE_18)
    health_check_path                = "/health"
    azure_files_auth_enabled          = true # Ensure App Service uses Azure Files (CKV_AZURE_88)
  }

  identity {
    type = "SystemAssigned" # Ensure Managed identity provider is enabled for app services (CKV_AZURE_71)
  }
  
  health_check_path = "/health" # Ensure app service configures health check (CKV_AZURE_213)
}

resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  sku {
    name = "Basic"
  }

  admin_enabled                  = false
  vulnerability_scanning_enabled  = true
  geo_replication_enabled         = true
  quarantine_enabled              = true
  retention_policy {
    days    = 30
    enabled = true
  }
  
  zone_redundant = true
  public_network_access_enabled = false
  trusted_image = true
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  default_node_pool {
    name       = "default"
    node_count = 50
    vm_size    = "Standard_DS2_v2"
    os_type    = "Linux"
    os_disk {
      disk_size_gb     = 30
      caching          = "ReadWrite"
      managed_disk_type = "Ephemeral"
    }
  }

  private_cluster_enabled              = true
  enable_encryption_with_secrets       = true
  enable_azure_cni                      = true # Ensure AKS cluster has Azure CNI networking enabled (CKV2_AZURE_29)

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
    }
  }

  sku {
    name = "Standard_DS2_v2"
    tier = "Paid"
  }

  admin_username = ""

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  upgrade_channel = "Rapid"
  enable_azure_policy = true
  disk_encryption_set_id = azurerm_disk_encryption_set.this.id
}

resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2" # Ensure TLS version is set to the latest

  public_network_access_enabled = false # Restrict public access to storage blobs
  allow_blob_public_access = false # Ensure storage account is configured without blob anonymous access (CKV2_AZURE_47)

  # Remediation for CKV2_AZURE_33
  enable_private_endpoint = true
  
  # Remediation for CKV2_AZURE_41
  sas_expiration_policy {
    enabled = true
    days    = 30
  }

  # Remediation for CKV2_AZURE_38
  soft_delete {
    enabled = true
    retention_days = 30
  }

  # Remediation for CKV2_AZURE_1
  customer_managed_key {
    key_vault_id = azurerm_key_vault.example.id
    key_name     = "my-key"
    key_version  = "latest"
  }
}