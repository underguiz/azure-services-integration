resource "random_string" "function" {
  length           = 6
  special          = false
  upper            = false
}

resource "azurerm_service_plan" "services-integration" {
  name                = "servicesintegration"
  resource_group_name = data.azurerm_resource_group.services-integration.name
  location            = data.azurerm_resource_group.services-integration.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "services-integration" {
  name                = "services-integration-${random_string.function.result}"
  resource_group_name = data.azurerm_resource_group.services-integration.name
  location            = data.azurerm_resource_group.services-integration.location
  service_plan_id     = azurerm_service_plan.services-integration.id

  storage_account_name       = azurerm_storage_account.services-integration-function.name
  storage_account_access_key = azurerm_storage_account.services-integration-function.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config { 
    application_stack {
        python_version = "3.9"
    }
  }

  app_settings = {
    "EventHubConn"   = azurerm_eventhub_namespace.services-integration.default_primary_connection_string
    "EventHubName"   = "${azurerm_eventhub_namespace.services-integration.name}.servicebus.windows.net"
    "DestEventHub"   = azurerm_eventhub.integration-hub.name
    "StorageAccConn" = azurerm_storage_account.services-integration.primary_connection_string
  }

  lifecycle {
    ignore_changes = [
      sticky_settings,
      site_config
    ]
  }
}