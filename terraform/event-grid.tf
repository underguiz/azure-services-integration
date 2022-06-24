resource "azurerm_eventgrid_system_topic" "services-integration" {
  name                   = "source-blobs"
  resource_group_name    = data.azurerm_resource_group.services-integration.name
  location               = data.azurerm_resource_group.services-integration.location
  source_arm_resource_id = azurerm_storage_account.services-integration.id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type         = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.event-grid.id ] 
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "services-integration" {
  name                = "source-blobs"
  system_topic        = azurerm_eventgrid_system_topic.services-integration.name
  resource_group_name = data.azurerm_resource_group.services-integration.name

  included_event_types = ["Microsoft.Storage.BlobCreated"]
  
  subject_filter { 
    subject_begins_with = "/blobServices/default/containers/${azurerm_storage_container.source-blobs.name}"
  }

  eventhub_endpoint_id = azurerm_eventhub.source-hub.id

}