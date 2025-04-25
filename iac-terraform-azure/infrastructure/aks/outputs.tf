output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "aks_kube_config" {
  description = "Kube config for AKS"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
}