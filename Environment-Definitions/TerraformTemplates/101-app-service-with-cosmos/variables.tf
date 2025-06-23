variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "appcos"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "australiacentral"
}

variable "runtime_type" {
  description = "Runtime type for the App Service (python, nodejs, or java)"
  type        = string
  default     = "java"
  validation {
    condition     = contains(["python", "nodejs", "java"], var.runtime_type)
    error_message = "Valid values for runtime_type are: python, nodejs, java."
  }
}

variable "repo_url" {
  description = "URL of the GitHub repository containing the application code"
  type        = string
  default     = "https://github.com/azure-samples/todo-java-mongo"
  validation {
    condition     = contains(["https://github.com/azure-samples/todo-java-mongo", "https://github.com/azure-samples/todo-nodejs-mongo", "https://github.com/azure-samples/todo-python-mongo"], var.repo_url)
    error_message = "Valid values for repo_url are: https://github.com/azure-samples/todo-java-mongo, https://github.com/azure-samples/todo-nodejs-mongo, https://github.com/azure-samples/todo-python-mongo."
  }
}

variable "cosmos_database_name" {
  description = "Name of the Cosmos DB database"
  type        = string
  default     = "TodoDB"
}

variable "use_apim" {
  description = "Flag to use Azure API Management"
  type        = bool
  default     = false
}

variable "apim_sku" {
  description = "API Management SKU"
  type        = string
  default     = "Consumption"
}
