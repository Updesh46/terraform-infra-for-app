variable "resource_group_name" {
    description = "The name of the resource group where resources will be created."
    type        = string
    default     = "infrarg"
}

variable "resource_group_location" {
    description = "The Azure region where resources will be created."
    type        = string
    default     = "westus"
}

variable "vnet_name" {
    description = "The name of the virtual network."
    type        = string
    default     = "vnetinfra"
}


variable "subnet_frontend_name" {
    description = "The name of the frontend subnet."
    type        = string
    default     = "subnetfrontend"
}


variable "key_vault_name" {
    description = "The name of the Azure Key Vault."
    type        = string
    default     = "keyvaultinfra12355678"
}

