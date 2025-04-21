#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧱 VNet + Network Watcher Deployment Script
# Deploys a VNet and manually scoped Network Watcher into a target resource group
# -----------------------------------------------------------------------------

# 🧰 Usage Help
function show_help() {
  echo ""
  echo "🚀 Deploy a VNet and Network Watcher into a single resource group"
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

if [[ "$RG" == "-h" || "$RG" == "--help" || -z "$RG" ]]; then
  show_help
fi

# 📋 Summary
echo "📦 Resource Group: $RG"
echo "🌍 Location: $LOCATION"
echo "📁 Bicep Template: $BICEP_FILE"

# 🔍 Check or Create Resource Group
echo "🔎 Checking if resource group exists..."
if ! az group show --name "$RG" &>/dev/null; then
  echo "📂 Creating resource group $RG in $LOCATION..."
  az group create --name "$RG" --location "$LOCATION"
else
  echo "✅ Resource group already exists."
fi

# 🚀 Deploy the VNet + Network Watcher
echo "🛠️ Deploying infrastructure..."
az deployment group create \
  --resource-group "$RG" \
  --template-file "$BICEP_FILE"

echo ""
echo "🎉 Deployment complete!"
echo "🔗 Your VNet and Network Watcher are ready inside: $RG"
