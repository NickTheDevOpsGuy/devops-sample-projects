#!/usr/bin/env bash
set -euo pipefail

# 1. Verify kubectl connectivity
kubectl get nodes --no-headers || { echo "No nodes"; exit 1; }

# 2. Verify metrics API access
az monitor metrics list \
  --resource "$(az aks show -g $RG -n $CLUSTER_NAME --query id -o tsv)" \
  --metric node_cpu_usage_percentage \
  --interval PT1M \
  --output json | jq '.value | length > 0' \
    || { echo "No metrics returned"; exit 1; }

echo "Connectivity & metrics OK"
