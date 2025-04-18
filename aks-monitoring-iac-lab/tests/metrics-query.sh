#!/usr/bin/env bash
set -euo pipefail

echo "📊 Testing metrics API..."
RG="YourResourceGroupName"
DEP=$(az deployment group show -g "${RG}" -n main --query properties.outputs -o json)
CLUSTER=$(echo "${DEP}" | jq -r .aksClusterName.value)

COUNT=$(az monitor metrics list \
  --resource "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/${RG}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER}" \
  --metric "node_cpu_usage_percentage" --interval PT1M --query "value | length(@)" -o tsv)

if [[ "$COUNT" -gt 0 ]]; then
  echo "✅ Metrics data available"
else
  echo "ERROR: No metrics data"
  exit 1
fi
