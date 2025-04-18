#!/usr/bin/env bash
set -euo pipefail

RG=${1:-YourResourceGroupName}
DEP=$(az deployment group show -g "${RG}" -n main --query properties.outputs -o json)
CLUSTER=$(echo "${DEP}" | jq -r .aksClusterName.value)
WORKSPACE_ID=$(echo "${DEP}" | jq -r .logAnalyticsWorkspaceId.value)

echo "➡️ Querying node CPU %..."
az monitor metrics list \
  --resource "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/${RG}/providers/Microsoft.ContainerService/managedClusters/${CLUSTER}" \
  --metric "node_cpu_usage_percentage" \
  --interval PT1M

echo "➡️ Querying container logs..."
az monitor log-analytics query \
  --workspace "${WORKSPACE_ID}" \
  --analytics-query "ContainerLog | where Image contains 'nginx' | take 20"
