output "web_app_name" {
  description = "The name of the web app"
  value       = azurerm_windows_web_app.web_app.name
}

output "web_app_url" {
  description = "The default URL of the web app"
  value       = "https://${azurerm_windows_web_app.web_app.default_hostname}"
}

output "service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.hosting_plan.id
}
