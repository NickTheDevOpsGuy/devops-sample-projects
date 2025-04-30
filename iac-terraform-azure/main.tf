module "network" {
  source              = "./network"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "aks" {
  source              = "./aks"
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "storage" {
  source                = "./storage"
  storage_account_name  = var.storage_account_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  account_tier          = var.account_tier
  replication_type      = var.replication_type
}