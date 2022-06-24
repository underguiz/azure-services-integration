resource "azurerm_user_assigned_identity" "event-grid" {
  resource_group_name = data.azurerm_resource_group.services-integration.name
  location            = data.azurerm_resource_group.services-integration.location

  name = "event-grid"
}

resource "azurerm_role_assignment" "event-grid-event-hub" {
  scope                = azurerm_eventhub.source-hub.id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = azurerm_user_assigned_identity.event-grid.principal_id
}

resource "azurerm_role_assignment" "function-storage-account" {
  scope                = azurerm_storage_account.services-integration.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.services-integration.identity.0.principal_id
}

resource "azurerm_role_assignment" "function-event-hub" {
  scope                = azurerm_eventhub.integration-hub.id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = azurerm_linux_function_app.services-integration.identity.0.principal_id
}