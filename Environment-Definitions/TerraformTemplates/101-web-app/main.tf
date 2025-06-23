resource "random_string" "resource_suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  resource_prefix = var.resource_prefix != "" ? var.resource_prefix : "a${random_string.resource_suffix.result}"
  hosting_plan_name = "${local.resource_prefix}-hp"
  web_app_name = "${local.resource_prefix}-hp"
}

resource "azurerm_service_plan" "hosting_plan" {
  name                = local.hosting_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = "S1"

  tags = var.tags
}

resource "azurerm_windows_web_app" "web_app" {
  name                = local.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.hosting_plan.id
  
  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  
  tags = var.tags
}
