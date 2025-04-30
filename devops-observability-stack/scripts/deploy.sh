#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🚀 Deploy DevOps Observability Stack (Minikube or AKS)
# -----------------------------------------------------------------------------

function usage() {
  echo ""
  echo "🚀 Deploy the DevOps Observability Stack with Prometheus, Loki, and Grafana"
  echo ""
  echo "Usage:"
  echo "  ./deploy.sh --env <minikube|aks> [--resource-group <name>] [--help]"
  echo ""
  echo "Options:"
  echo "  --env                Target environment: 'minikube' or 'aks' (required)"
  echo "  --resource-group     Azure Resource Group (required for AKS)"
  echo "  --help               Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./deploy.sh --env minikube"
  echo "  ./deploy.sh --env aks --resource-group MyResourceGroup"
  echo ""
  exit 0
}

ENV=""
RESOURCE_GROUP=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --env)
      ENV="$2"
      shift 2
      ;;
    --resource-group)
      RESOURCE_GROUP="$2"
      shift 2
      ;;
    --help|-h)
      usage
      ;;
    *)
      echo "❌ Unknown option: $1"
      usage
      ;;
  esac
done

if [[ -z "$ENV" ]]; then
  echo "❌ Missing required --env argument."
  usage
fi

echo "🌍 Target environment: $ENV"

# -----------------------------------------------------------------------------
# Helm Chart Installation
# -----------------------------------------------------------------------------

echo "📦 Adding Helm repos..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

if [[ "$ENV" == "minikube" ]]; then
  echo "🔧 Setting up Minikube environment..."
  kubectl config use-context minikube

  echo "📦 Installing Prometheus stack (Minikube)..."
  helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
    -f environments/minikube/values-minikube.yaml --namespace monitoring --create-namespace

  echo "📦 Installing Loki stack with Grafana (Minikube)..."
  helm upgrade --install loki grafana/loki-stack \
    -f environments/minikube/values-minikube.yaml --namespace monitoring

  GRAFANA_SVC="loki-grafana"

elif [[ "$ENV" == "aks" ]]; then
  if [[ -z "$RESOURCE_GROUP" ]]; then
    echo "❌ Missing required --resource-group argument for AKS deployment."
    usage
  fi

  echo "🔧 Setting up AKS environment..."
  az aks get-credentials --resource-group "$RESOURCE_GROUP" --name observability-aks-cluster

  echo "📦 Installing Prometheus stack (AKS)..."
  helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
    -f environments/aks/values-aks.yaml --namespace monitoring --create-namespace

  echo "📦 Installing Loki stack with Grafana (AKS)..."
  helm upgrade --install loki grafana/loki-stack \
    -f environments/aks/values-aks.yaml --namespace monitoring

  GRAFANA_SVC="loki-grafana"

else
  echo "❌ Unknown environment: $ENV"
  usage
fi

echo "✅ Deployment complete!"
echo "🧭 Access Grafana UI with: kubectl port-forward svc/$GRAFANA_SVC -n monitoring 3000:80"
echo "🔁 Starting port-forward on http://localhost:3000 ..."
kubectl -n monitoring port-forward svc/$GRAFANA_SVC 3000:80 &