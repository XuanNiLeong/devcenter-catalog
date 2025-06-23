# App Service with Cosmos DB Terraform Template

This Terraform template deploys an Azure App Service with a Cosmos DB account. It is designed to be used with the Azure Developer CLI (AZD) and is compatible with the original ARM template functionality.

## Features

- Deploys an App Service with a choice of runtime (Python, Node.js, or Java)
- Sets up a Cosmos DB account with MongoDB API
- Configures Application Insights for monitoring
- Creates a Log Analytics workspace
- Provisions a Key Vault for storing secrets
- Configures a managed identity for secure authentication
- Sets up CORS to enable cross-origin requests

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI installed and authenticated (`az login`)
- An Azure subscription

## Quick Start

1. Clone the repo or initialize with AZD
2. Navigate to the template directory
3. Initialize Terraform:
   ```shell
   terraform init
   ```
4. Plan the deployment:
   ```shell
   terraform plan -out tfplan
   ```
5. Apply the deployment:
   ```shell
   terraform apply tfplan
   ```

## Parameters

| Name | Description | Type | Default |
|------|-------------|------|---------|
| resource_name_prefix | Prefix for resource names | string | "appcos" |
| location | Azure region for deployment | string | "eastus" |
| runtime_type | App Service runtime (python, nodejs, java) | string | "java" |
| repo_url | GitHub repo URL for the app | string | "https://github.com/azure-samples/todo-java-mongo" |
| cosmos_database_name | Name of the Cosmos DB database | string | "TodoDB" |
| use_apim | Flag to use API Management | bool | false |
| apim_sku | API Management SKU | string | "Consumption" |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | The name of the resource group |
| app_service_name | The name of the App Service |
| app_service_url | The URL of the App Service |
| cosmos_db_name | The name of the Cosmos DB account |
| cosmos_db_endpoint | The endpoint URL of the Cosmos DB account |
| instrumentation_key | The instrumentation key for Application Insights |
| key_vault_name | The name of the Key Vault |
| key_vault_uri | The URI of the Key Vault |

## Supported Sample Apps

This template is designed to work with the following sample applications:

- [Todo App with Java and MongoDB](https://github.com/azure-samples/todo-java-mongo)
- [Todo App with Node.js and MongoDB](https://github.com/azure-samples/todo-nodejs-mongo)
- [Todo App with Python and MongoDB](https://github.com/azure-samples/todo-python-mongo)

## Notes

- The App Service is configured with CORS to allow requests from any origin.
- A managed identity is created and granted access to Key Vault secrets.
- The Cosmos DB connection string is stored as a secret in Key Vault.

## Contributing

Please follow the standard contribution process for this repository.

## License

See the LICENSE file for details.
