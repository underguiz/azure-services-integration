resource "random_string" "storage-account" {
  length           = 6
  special          = false
  upper            = false
}

resource "azurerm_storage_account" "services-integration" {
  name                     = "servicesintegration${random_string.storage-account.result}"
  resource_group_name      = data.azurerm_resource_group.services-integration.name
  location                 = data.azurerm_resource_group.services-integration.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_account" "services-integration-function" {
  name                     = "servicesintfunction${random_string.storage-account.result}"
  resource_group_name      = data.azurerm_resource_group.services-integration.name
  location                 = data.azurerm_resource_group.services-integration.location
  account_tier             = "Standard"
  account_kind             = "Storage"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "source-blobs" {
  name                  = "source-blobs"
  storage_account_name  = azurerm_storage_account.services-integration.name
  container_access_type = "private"
}