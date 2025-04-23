#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧹 AKS Monitoring Lab Cleanup Script
# Deletes: AKS Resource Group + Managed Grafana (from any RG)
# -----------------------------------------------------------------------------

# 📘 Show Help
function show_help() {
  echo ""
  echo "🧹 Clean up AKS Monitoring Lab resources (AKS + Grafana)"
  echo ""
  echo "Usage:"
  echo "  ./cleanup.sh <resource-group> <environment>"
  echo ""
  echo "Example:"
  echo "  ./cleanup.sh NickClarkRG dev"
  echo ""
  echo "Arguments:"
  echo "  <resource-group>   Required. Name of the AKS resource group."
  echo "  <environment>      Required. Environment name (e.g., dev, prod)"
  echo ""
  exit 0
}

# 🧪 Parse Arguments
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 2 ]]; then
  show_help
fi

RG="$1"
ENV="$2"
GRAFANA_PREFIX="grafana-${ENV}"

echo "🧹 Starting cleanup for environment: $ENV"
echo "📦 Target AKS Resource Group: $RG"
echo "📊 Looking for Grafana instances with name starting: $GRAFANA_PREFIX"
echo ""

read -p "⚠️  Are you sure you want to delete these resources? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Cleanup aborted by user."
  exit 1
fi

# 🔥 Attempt to delete the AKS resource group
echo ""
echo "📦 Checking if resource group '$RG' exists..."
if az group show --name "$RG" &>/dev/null; then
  echo "🔥 Deleting resource group: $RG ..."
  az group delete --name "$RG" --yes --no-wait
else
  echo "⚠️ Resource group '$RG' does not exist or was already deleted."
fi

# 🔍 Find and delete Grafana instances that match the prefix
echo ""
echo "📊 Searching for Azure Managed Grafana instances starting with '$GRAFANA_PREFIX'..."
GRAFANA_LIST=$(az grafana list -o json)

echo "$GRAFANA_LIST" | jq -c ".[] | select(.name | startswith(\"$GRAFANA_PREFIX\"))" | while read -r grafana; do
  GRAFANA_NAME=$(echo "$grafana" | jq -r .name)
  GRAFANA_RG=$(echo "$grafana" | jq -r .resourceGroup)

  echo "🔥 Deleting Grafana instance '$GRAFANA_NAME' in resource group '$GRAFANA_RG'..."
  az grafana delete --name "$GRAFANA_NAME" --resource-group "$GRAFANA_RG" --yes
  echo "✅ Grafana instance '$GRAFANA_NAME' deleted."
done

echo ""
echo "✅ Cleanup complete. Some deletions may still be processing in Azure."