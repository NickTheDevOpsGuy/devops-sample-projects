#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧹 Cleanup Script for AKS Monitoring Lab
# Deletes all deployed resources, including Grafana
# -----------------------------------------------------------------------------

RG="${1:-}"
LOCATION="${2:-eastus}"

if [[ -z "$RG" || "$RG" == "-h" || "$RG" == "--help" ]]; then
  echo ""
  echo "🧹 Cleanup all resources in a resource group, including Azure Managed Grafana"
  echo ""
  echo "Usage:"
  echo "  ./cleanup.sh <resource-group> [location]"
  echo ""
  echo "Example:"
  echo "  ./cleanup.sh NickClarkRG eastus"
  echo ""
  exit 0
fi

echo "🧨 Starting cleanup for resource group: $RG"

# 🎯 Check if RG exists
if ! az group show --name "$RG" &>/dev/null; then
  echo "❌ Resource group $RG does not exist. Nothing to clean up."
  exit 1
fi

# 🧠 Try to find any Grafana instance by name prefix (e.g., grafana-dev)
echo "🔎 Checking for Azure Managed Grafana in $RG..."
grafana_names=$(az grafana list --resource-group "$RG" --query "[].name" -o tsv)

if [[ -n "$grafana_names" ]]; then
  for gname in $grafana_names; do
    echo "🗑️ Deleting Grafana instance: $gname"
    az grafana delete --name "$gname" --resource-group "$RG" --yes
  done
else
  echo "✅ No Grafana instances found in $RG."
fi

# 🧹 Delete the resource group
echo ""
echo "🗑️ Deleting entire resource group: $RG..."
az group delete --name "$RG" --yes --no-wait

echo "🎉 Cleanup started. The resource group and all resources are being deleted."