output "vnet_id" {
  description = "The ID of the deployed Virtual Network"
  value       = module.network.vnet_id
}

output "aks_cluster_name" {
  description = "The name of the deployed AKS Cluster"
  value       = module.aks.aks_cluster_name
}

output "aks_kube_config" {
  description = "Kube config for the deployed AKS Cluster"
  value       = module.aks.aks_kube_config
}

output "storage_account_name" {
  description = "The name of the deployed Storage Account"
  value       = module.storage.storage_account_name
}