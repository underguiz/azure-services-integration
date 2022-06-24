resource "random_string" "event-hub" {
  length           = 6
  special          = false
  upper            = false
}

resource "azurerm_eventhub_namespace" "services-integration" {
  name                = "services-integration-${random_string.event-hub.result}"
  resource_group_name = data.azurerm_resource_group.services-integration.name
  location            = data.azurerm_resource_group.services-integration.location
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "source-hub" {
  name                = "source-hub"
  namespace_name      = azurerm_eventhub_namespace.services-integration.name
  resource_group_name = data.azurerm_resource_group.services-integration.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub" "integration-hub" {
  name                = "integration-hub"
  namespace_name      = azurerm_eventhub_namespace.services-integration.name
  resource_group_name = data.azurerm_resource_group.services-integration.name
  partition_count     = 1
  message_retention   = 1
}