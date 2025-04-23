#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# ☁️ Modular AKS Monitoring IaC Deployment Script
# -----------------------------------------------------------------------------

function show_help() {
  echo ""
  echo "🚀 Deploy modularized AKS monitoring lab using Bicep and GitOps"
  echo ""
  echo "Usage:"
  echo "  ./deploy.sh <resource-group> [environment] [location]"
  echo ""
  echo "Arguments:"
  echo "  <resource-group>   Required. Azure resource group name."
  echo "  [environment]      Optional. dev or prod. Default: dev"
  echo "  [location]         Optional. Azure region. Default: eastus"
  echo ""
  exit 0
}

# 🧪 Parse Inputs
RG="${1:-}"
ENV="${2:-dev}"
LOCATION="${3:-eastus}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BICEP_FILE="${ROOT_DIR}/infrastructure/bicep/main.bicep"
PARAM_FILE="${ROOT_DIR}/infrastructure/bicep/parameters.${ENV}.json"
FLUX_BOOTSTRAP_DIR="${ROOT_DIR}/aks-monitoring-iac-lab/flux-bootstrap"
FLUX_SOURCE="${FLUX_BOOTSTRAP_DIR}/source-${ENV}.yaml"
FLUX_KUSTOMIZATION="${FLUX_BOOTSTRAP_DIR}/kustomization-${ENV}.yaml"
DEPLOYMENT_NAME="main"

if [[ "$RG" == "-h" || "$RG" == "--help" || -z "$RG" ]]; then
  show_help
fi

if [[ ! -f "$PARAM_FILE" ]]; then
  echo "❌ Parameter file not found: $PARAM_FILE"
  exit 1
fi

# 📋 Summary
echo ""
echo "📦 Resource Group: $RG"
echo "🌍 Location: $LOCATION"
echo "🧪 Environment: $ENV"
echo "📁 Bicep Template: $BICEP_FILE"
echo "📑 Parameters File: $PARAM_FILE"
echo ""

# 🔍 Check or Create Resource Group
echo "🔎 Checking if resource group exists..."
if ! az group show --name "$RG" &>/dev/null; then
  echo "📂 Creating resource group $RG in $LOCATION..."
  az group create --name "$RG" --location "$LOCATION"
else
  echo "✅ Resource group already exists."
fi

# 🚀 Deploy infrastructure
echo ""
echo "🛠️  [1/3] Deploying infrastructure with Bicep..."
start_time=$(date +%s)
az deployment group create \
  --name "$DEPLOYMENT_NAME" \
  --resource-group "$RG" \
  --template-file "$BICEP_FILE" \
  --parameters "@$PARAM_FILE"

# 📊 Monitor deployment operations
echo ""
echo "📊 [2/3] Watching real-time deployment progress..."

while true; do
  operations=$(az deployment operation group list \
    --resource-group "$RG" \
    --name "$DEPLOYMENT_NAME" \
    --query "[].{Resource:properties.targetResource.resourceName, Type:properties.targetResource.resourceType, Status:properties.provisioningState, Operation:properties.provisioningOperation}" \
    --output table)

  clear
  echo "🛠️  Deployment: $DEPLOYMENT_NAME"
  echo "⏱️  Time: $(date)"
  echo "$operations"

  if ! echo "$operations" | grep -q "Running"; then
    echo ""
    echo "✅ Deployment operations completed!"
    break
  fi

  elapsed=$(( $(date +%s) - start_time ))
  if [[ $elapsed -gt 600 ]]; then
    echo "⚠️ Deployment is taking longer than 10 minutes..."
  fi

  sleep 10
done

# 🌀 GitOps: Apply Flux configs
echo ""
echo "🔁 [3/3] Bootstrapping Flux for GitOps..."
if [[ -f "$FLUX_SOURCE" && -f "$FLUX_KUSTOMIZATION" ]]; then
  echo "📁 Applying $FLUX_SOURCE and $FLUX_KUSTOMIZATION..."
  kubectl apply -f "$FLUX_SOURCE"
  kubectl apply -f "$FLUX_KUSTOMIZATION"
  echo "✅ Flux bootstrapped for '$ENV'"
else
  echo "⚠️  No Flux config found for '$ENV' — skipping GitOps bootstrap"
fi

# 🧠 Try to pull AKS credentials
AKS_NAME="aks-${ENV}"
echo ""
echo "🔐 Getting AKS credentials for: $AKS_NAME in $RG..."
if az aks show --name "$AKS_NAME" --resource-group "$RG" &>/dev/null; then
  echo "🔐 Fetching kubeconfig..."
  az aks get-credentials --resource-group "$RG" --name "$AKS_NAME" --overwrite-existing
  echo "✅ Kubeconfig updated. Try: kubectl get nodes"
else
  echo "⚠️  AKS cluster '$AKS_NAME' not found in $RG. Skipping kubeconfig setup."
fi

echo ""
echo "🎉 All done. Go dominate your cloud!"