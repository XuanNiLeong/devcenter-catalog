output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the resource group"
}

output "app_service_name" {
  value       = azurerm_linux_web_app.app.name
  description = "The name of the App Service"
}

output "cosmos_db_name" {
  value       = azurerm_cosmosdb_account.db.name
  description = "The name of the Cosmos DB account"
}

output "cosmos_db_endpoint" {
  value       = azurerm_cosmosdb_account.db.endpoint
  description = "The endpoint URL of the Cosmos DB account"
}

output "instrumentation_key" {
  value       = azurerm_application_insights.appinsights.instrumentation_key
  description = "The instrumentation key for Application Insights"
  sensitive   = true
}

output "key_vault_name" {
  value       = azurerm_key_vault.keyvault.name
  description = "The name of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.keyvault.vault_uri
  description = "The URI of the Key Vault"
}
