variable "location" {
  type        = string
  description = "Location to deploy the environment resources"
  default     = "westus"  # Based on the hardcoded value in the ARM template
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to environment resources"
  default     = {}
}
