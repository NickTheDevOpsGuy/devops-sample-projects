#!/usr/bin/env bash
set -euo pipefail

RG=${1:-YourResourceGroupName}
echo "🧹 Deleting resource group ${RG}..."
az group delete --name "${RG}" --yes --no-wait
