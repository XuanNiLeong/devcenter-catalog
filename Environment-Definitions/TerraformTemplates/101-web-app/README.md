# Azure Web App Terraform Template

This Terraform template deploys an Azure Web App with an App Service Plan.

## Resources Deployed

- **App Service Plan**: A Standard tier (S1) plan for hosting web apps
- **Web App**: A Windows-based web app running .NET 6.0

## Variables

| Name | Description | Default |
|------|-------------|---------|
| location | Azure region to deploy resources | westus |
| resource_group_name | Name of the resource group | |
| resource_prefix | Prefix for resource names | Generated using random string |
| tags | Tags to apply to resources | {} |

## Outputs

| Name | Description |
|------|-------------|
| web_app_name | The name of the deployed web app |
| web_app_url | The default URL of the web app |
| service_plan_id | The ID of the App Service Plan |

## Deployment Steps

1. Initialize Terraform
   ```bash
   terraform init
   ```

2. Validate Terraform configuration
   ```bash
   terraform validate
   ```

3. Create a plan and review changes
   ```bash
   terraform plan -out=tfplan
   ```

4. Apply the changes
   ```bash
   terraform apply tfplan
   ```

## Note

This template was converted from an ARM template and provides equivalent functionality in Terraform format.
