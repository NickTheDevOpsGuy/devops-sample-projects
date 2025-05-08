#!/bin/bash

# 🚀 Azure Web App Deployment Script
# For use in DevOps multi-stage pipeline or manual CLI deployment

set -e

# ========================
# 🔧 Configuration
# ========================
APP_NAME=$1
RESOURCE_GROUP=$2
IMAGE_NAME=$3

# 🧠 Defaults for local testing
[[ -z "$APP_NAME" ]] && APP_NAME="devops-demo-app"
[[ -z "$RESOURCE_GROUP" ]] && RESOURCE_GROUP="NickClarkRG"
[[ -z "$IMAGE_NAME" ]] && IMAGE_NAME="fastapi-devops-app:latest"

# ========================
# 🛠️ Helper Functions
# ========================

log() {
    echo -e "📣 $1"
}

error() {
    echo -e "❌ $1" >&2
    exit 1
}

check_dependencies() {
    command -v az >/dev/null 2>&1 || error "Azure CLI (az) is not installed!"
    command -v docker >/dev/null 2>&1 || error "Docker is not installed!"
}

login_azure() {
    log "🔐 Logging into Azure..."
    az account show >/dev/null 2>&1 || az login
}

deploy_image() {
    log "📦 Building Docker image: $IMAGE_NAME"
    docker build -t $IMAGE_NAME .

    log "☁️ Pushing image to Azure Container Registry (ACR) or Docker Hub... (not implemented here)"
    # TODO: az acr login + docker push
}

deploy_webapp() {
    log "🌍 Deploying to Azure Web App: $APP_NAME in $RESOURCE_GROUP"
    az webapp config container set \
        --name "$APP_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --docker-custom-image-name "$IMAGE_NAME" \
        --docker-registry-server-url "https://index.docker.io/v1/"
}

# ========================
# 🚀 Execution Flow
# ========================

check_dependencies
login_azure
deploy_image
deploy_webapp

log "✅ Deployment complete!"