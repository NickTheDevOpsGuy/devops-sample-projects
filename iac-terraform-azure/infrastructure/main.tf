module "network" {
  source     = "../modules/network"
  vnet_name  = var.vnet_name
  address_space = var.address_space
  location   = var.location
  resource_group_name = var.resource_group_name
}

module "aks" {
  source     = "../modules/aks"
  location   = var.location
  resource_group_name = var.resource_group_name
}

module "storage" {
  source     = "../modules/storage"
  location   = var.location
  resource_group_name = var.resource_group_name
}