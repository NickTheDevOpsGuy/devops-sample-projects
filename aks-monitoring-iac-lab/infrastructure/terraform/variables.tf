variable "rg_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "NickClarkRG"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "workspace_name" {
  description = "Log Analytics workspace name"
  type        = string
  default     = "aks-monitoring-ws"
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
  default     = "MyAKSCluster"
}

variable "ssh_public_key" {
  description = "SSH public key for Linux nodes"
  type        = string
}

variable "agent_count" {
  description = "Number of nodes in the default agent pool"
  type        = number
  default     = 2
}

variable "agent_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Admin username for Linux nodes"
  type        = string
  default     = "azureuser"
}
