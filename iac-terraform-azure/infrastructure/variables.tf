variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Azure Resource Group"
  type        = string
  default     = "NickClarkRG"
}

variable "vnet_name" {
  type        = string
  default     = "main-vnet"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}