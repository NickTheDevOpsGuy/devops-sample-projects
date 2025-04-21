#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧱 Modular Bicep Deployment Script
# Deploys infrastructure using environment-specific parameter file
# -----------------------------------------------------------------------------

# 📦 Usage Help
function show_help() {
  echo ""
  echo "🚀 Deploy modularized infrastructure using Bicep and parameters.dev.json"
  echo ""
  echo "Usage:"
  echo "  ./deploy.sh <resource-group> [location]"
  echo ""
  echo "Example:"
  echo "  ./deploy.sh NickClarkRG eastus"
  echo ""
  echo "Arguments:"
  echo "  <resource-group>   Required. Target Azure resource group."
  echo "  [location]         Optional. Azure region (default: eastus)."
  echo ""
  exit 0
}

# 🧪 Parse Inputs
RG="${1:-}"
LOCATION="${2:-eastus}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BICEP_FILE="${ROOT_DIR}/infrastructure/bicep/main.bicep"
PARAM_FILE="${ROOT_DIR}/infrastructure/bicep/parameters.dev.json"

if [[ "$RG" == "-h" || "$RG" == "--help" || -z "$RG" ]]; then
  show_help
fi

# 📋 Summary
echo "📦 Resource Group: $RG"
echo "🌍 Location: $LOCATION"
echo "📁 Bicep Template: $BICEP_FILE"
echo "📑 Parameters File: $PARAM_FILE"

# 🔍 Check or Create Resource Group
echo "🔎 Checking if resource group exists..."
if ! az group show --name "$RG" &>/dev/null; then
  echo "📂 Creating resource group $RG in $LOCATION..."
  az group create --name "$RG" --location "$LOCATION"
else
  echo "✅ Resource group already exists."
fi

# 🚀 Deploy the modular Bicep templates
echo "🛠️ Deploying infrastructure modules..."
az deployment group create \
  --resource-group "$RG" \
  --template-file "$BICEP_FILE" \
  --parameters "@$PARAM_FILE"

echo ""
echo "🎉 Deployment complete!"
echo "🔗 All infrastructure deployed into: $RG"

# 🎯 Try to pull AKS credentials if the cluster exists
AKS_NAME="aks-${ENV}"

echo ""
echo "🧠 Checking for AKS cluster: $AKS_NAME in $RG..."

if az aks show --name "$AKS_NAME" --resource-group "$RG" &>/dev/null; then
  echo "🔐 Fetching AKS credentials for '$AKS_NAME'..."
  az aks get-credentials --resource-group "$RG" --name "$AKS_NAME" --overwrite-existing
  echo "✅ AKS kubeconfig updated. You can now run: kubectl get nodes"
else
  echo "⚠️  AKS cluster '$AKS_NAME' not found in $RG. Skipping kubeconfig setup."
fi
