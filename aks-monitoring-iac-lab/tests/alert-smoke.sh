#!/usr/bin/env bash
set -euo pipefail

echo "🚨 Testing alert list..."
az monitor metrics alert list --resource-group YourResourceGroupName --query "[?name=='HighNodeCPU']" -o table \
  && echo "✅ Alert exists" \
  || { echo "ERROR: Alert not found"; exit 1; }
