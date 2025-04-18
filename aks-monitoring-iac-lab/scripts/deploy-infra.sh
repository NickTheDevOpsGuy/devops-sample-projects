#!/usr/bin/env bash
set -euo pipefail

RG="${1:-YourResourceGroupName}"
ENV="${2:-dev}"

echo "➡️ Deploying infrastructure to ${RG} (${ENV})..."
az account set --subscription "<YOUR-SUBSCRIPTION-ID>"
az group create --name "${RG}" --location eastus

az deployment group create \
  --resource-group "${RG}" \
  --template-file ../infrastructure/bicep/main.bicep \
  --parameters ../infrastructure/bicep/parameters.${ENV}.json \
  --query properties.outputs
