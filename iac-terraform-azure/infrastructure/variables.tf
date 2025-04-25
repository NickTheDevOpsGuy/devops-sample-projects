variable "storage_account_name" {
  description = "Storage account name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "account_tier" {
  description = "Storage Account tier (Standard/Premium)"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Replication type (LRS, GRS, ZRS)"
  type        = string
  default     = "LRS"
}