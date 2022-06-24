provider "azurerm" {
  features {}
}

variable "services-integration-rg" {
  type    = string
  default = "services-integration"
}

data "azurerm_resource_group" "services-integration" {
    name = var.services-integration-rg
}

output "function-name" {
  value       = azurerm_linux_function_app.services-integration.name
  description = "Function Name"
}

output "storage-account" {
  value       = azurerm_storage_account.services-integration.name
  description = "Storage Account"
}