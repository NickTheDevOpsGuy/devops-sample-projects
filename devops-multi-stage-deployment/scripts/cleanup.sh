#!/bin/bash

# 💣 Azure Cleanup Script for DevOps Demo Project
# ⚠️ WARNING: This deletes Web Apps, Plans, and optionally Resource Group

set -e

# ============= ⚙️ CONFIGURATION ==================
RESOURCE_GROUP=${1:-"NickClarkRG"}
DELETE_RG=false  # Set to true to nuke entire resource group

APP_NAMES=("devops-demo-app-dev" "devops-demo-app-staging" "devops-demo-app-prod")
PLAN_NAME="devops-demo-plan"

# ============= 🔧 FUNCTIONS =====================

log() {
    echo -e "📣 $1"
}

warn() {
    echo -e "⚠️  $1"
}

confirm() {
    warn "This script will permanently delete resources in resource group: $RESOURCE_GROUP"
    warn "Apps to delete: ${APP_NAMES[*]}"
    read -p "Type 'yes' to proceed: " confirm
    [[ "$confirm" != "yes" ]] && echo "❌ Aborting." && exit 1
}

delete_webapps() {
    for app in "${APP_NAMES[@]}"; do
        log "🔥 Deleting Web App: $app"
        az webapp delete --name "$app" --resource-group "$RESOURCE_GROUP" || warn "App $app may not exist"
    done
}

delete_plan() {
    log "🗑️ Deleting App Service Plan: $PLAN_NAME"
    az appservice plan delete --name "$PLAN_NAME" --resource-group "$RESOURCE_GROUP" --yes || warn "Plan $PLAN_NAME may not exist"
}

delete_resource_group() {
    if [ "$DELETE_RG" = true ]; then
        log "💀 DELETING ENTIRE RESOURCE GROUP: $RESOURCE_GROUP"
        az group delete --name "$RESOURCE_GROUP" --yes --no-wait
    fi
}

# ============= 🚀 EXECUTION =====================

confirm
delete_webapps
delete_plan
delete_resource_group

log "✅ Cleanup complete."