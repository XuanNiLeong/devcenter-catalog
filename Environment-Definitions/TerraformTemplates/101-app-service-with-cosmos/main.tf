/*
* # App Service with Cosmos DB
*
* This terraform template deploys an Azure App Service with a Cosmos DB account.
* It supports deploying applications based on Python, Node.js, or Java runtimes.
* The template will set up all necessary resources including:
* - App Service Plan
* - App Service
* - Cosmos DB Account
* - Application Insights
* - Log Analytics
* - Key Vault
*/

# Generate random resource name
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location = var.location

  tags = {
    "azd-env-name" = var.resource_name_prefix
  }
}

# Create Log Analytics workspace
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "log-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "appi-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.workspace.id
}

# Create App Dashboard
resource "azurerm_portal_dashboard" "app_dashboard" {
  name                = "dash-${var.resource_name_prefix}-${random_string.resource_code.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags = {
    hidden-title = "Application Dashboard"
  }
  # Dashboard configuration would typically go here
  # This is a simplified version
  dashboard_properties = <<DASH
{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": {
            "x": 0,
            "y": 0,
            "colSpan": 6,
            "rowSpan": 4
          },
          "metadata": {
            "type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
            "inputs": [
              {
                "name": "resourceTypeMode",
                "value": "workspace"
              },
              {
                "name": "ComponentId",
                "value": "${azurerm_log_analytics_workspace.workspace.id}"
              }
            ]
          }
        }
      }
    }
  }
}
DASH
}

# Create User Managed Identity
resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "id-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                       = "kv-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.managed_identity.principal_id

    secret_permissions = [
      "Get", "List"
    ]
  }
}

# Create Cosmos DB Account
resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableMongo"
  }

  tags = {
    "azd-service-name" = "database"
  }
}

# Create Cosmos DB Database
resource "azurerm_cosmosdb_mongo_database" "db" {
  name                = var.cosmos_database_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.db.name
}

# Store Cosmos DB connection string in Key Vault
resource "azurerm_key_vault_secret" "cosmos_connection" {
  name         = "AZURE-COSMOS-CONNECTION-STRING"
  value        = azurerm_cosmosdb_account.db.connection_strings[0]
  key_vault_id = azurerm_key_vault.keyvault.id
}

# Create App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = "plan-${var.resource_name_prefix}-${random_string.resource_code.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Create App Service
resource "azurerm_app_service" "app" {
  name                = "${var.resource_name_prefix}-${random_string.resource_code.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
  https_only          = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.managed_identity.id]
  }

  site_config {
    linux_fx_version = var.runtime_type == "nodejs" ? "NODE|16-lts" : (var.runtime_type == "python" ? "PYTHON|3.9" : "JAVA|11-java11")
    cors {
      allowed_origins     = ["*"]
      support_credentials = true
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appinsights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appinsights.instrumentation_key
    "AZURE_CLIENT_ID"                       = azurerm_user_assigned_identity.managed_identity.client_id
    "AZURE_KEY_VAULT_ENDPOINT"              = azurerm_key_vault.keyvault.vault_uri
    "AZURE_COSMOS_DATABASE_NAME"            = var.cosmos_database_name
  }

  source_control {
    repo_url = var.repo_url
    branch   = "main"
  }

  tags = {
    "azd-service-name" = "web"
  }
}

# Get current client config for Key Vault access policies
data "azurerm_client_config" "current" {}
