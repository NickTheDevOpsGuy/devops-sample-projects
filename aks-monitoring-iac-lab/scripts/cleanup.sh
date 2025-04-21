#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧹 Cleanup Script — Destroys the specified Azure resource group
# -----------------------------------------------------------------------------

function show_help() {
  echo ""
  echo "🧹 Destroys a resource group and all associated resources."
  echo ""
  echo "Usage:"
  echo "  ./cleanup.sh <resource-group>"
  echo ""
  echo "Example:"
  echo "  ./cleanup.sh NickClarkRG"
  echo ""
  echo "⚠️  This is permanent! It will delete EVERYTHING in the resource group."
  echo ""
  exit 0
}

# 🧪 Parse input
RG="${1:-}"

if [[ "$RG" == "-h" || "$RG" == "--help" || -z "$RG" ]]; then
  show_help
fi

# 🔍 Confirm it exists
if ! az group show --name "$RG" &>/dev/null; then
  echo "❌ Resource group not found: $RG"
  exit 1
fi

# ⚠️ Confirmation prompt
echo "⚠️  You are about to DELETE the entire resource group: $RG"
read -rp "❓ Are you sure? Type the name of the resource group to confirm: " CONFIRM

if [[ "$CONFIRM" != "$RG" ]]; then
  echo "❌ Confirmation failed. Nothing was deleted."
  exit 1
fi

# 🚀 Delete it
echo "🔥 Deleting resource group $RG..."
az group delete --name "$RG" --yes --no-wait

echo "✅ Deletion initiated. It may take a few minutes to fully complete."
