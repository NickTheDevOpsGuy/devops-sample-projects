#!/usr/bin/env bash
set -euo pipefail

function usage() {
  echo ""
  echo "🚀 Deploy the DevOps Observability Stack"
  echo "Usage: ./deploy.sh --env <minikube|aks> [--resource-group <name>] [--help]"
  echo ""
  exit 0
}

ENV=""
RESOURCE_GROUP=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --env) ENV="$2"; shift 2 ;;
    --resource-group) RESOURCE_GROUP="$2"; shift 2 ;;
    --help|-h) usage ;;
    *) echo "❌ Unknown option: $1"; usage ;;
  esac
done

if [[ -z "$ENV" ]]; then
  echo "❌ Missing required --env argument."
  usage
fi

echo "🌍 Target environment: $ENV"

echo "📦 Adding Helm repos..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Ensure monitoring namespace exists before any installs or apply
echo "📦 Ensuring 'monitoring' namespace exists..."
kubectl get ns monitoring >/dev/null 2>&1 || kubectl create ns monitoring

if [[ "$ENV" == "minikube" ]]; then
  kubectl config use-context minikube

  echo "📦 Installing Prometheus stack..."
  helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
    -f environments/minikube/values-minikube.yaml \
    --namespace monitoring --create-namespace

  echo "🗑️  Deleting Grafana secret to reset password..."
  kubectl delete secret -n monitoring loki-grafana --ignore-not-found

  echo "📦 Installing Loki stack with Grafana..."
  helm upgrade --install loki grafana/loki-stack \
    -f environments/minikube/values-minikube.yaml \
    --namespace monitoring --create-namespace

elif [[ "$ENV" == "aks" ]]; then
  if [[ -z "$RESOURCE_GROUP" ]]; then
    echo "❌ --resource-group required for AKS."
    exit 1
  fi

  echo "🔧 Getting AKS credentials..."
  az aks get-credentials --resource-group "$RESOURCE_GROUP" --name observability-aks-cluster

  echo "📦 Installing Prometheus stack..."
  helm upgrade --install kube-prometheus prometheus-community/kube-prometheus-stack \
    -f environments/aks/values-aks.yaml \
    --namespace monitoring --create-namespace

  echo "🗑️  Deleting Grafana secret to reset password..."
  kubectl delete secret -n monitoring loki-grafana --ignore-not-found

  echo "📦 Installing Loki stack with Grafana..."
  helm upgrade --install loki grafana/loki-stack \
    -f environments/aks/values-aks.yaml \
    --namespace monitoring --create-namespace

else
  echo "❌ Unknown environment: $ENV"
  exit 1
fi

echo "📊 Applying all Grafana dashboard ConfigMaps..."
if compgen -G "manifests/grafana/*-dashboard-configmap.yaml" > /dev/null; then
  for file in manifests/grafana/*-dashboard-configmap.yaml; do
    echo "🔁 Applying $file"
    kubectl apply -f "$file"
  done
else
  echo "⚠️ No dashboard configmaps found in manifests/grafana/"
fi

echo "🔄 Restarting Grafana..."
GRAFANA_DEPLOY=$(kubectl get deploy -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath="{.items[0].metadata.name}" 2>/dev/null || true)
if [[ -n "$GRAFANA_DEPLOY" ]]; then
  kubectl rollout restart deployment/$GRAFANA_DEPLOY -n monitoring
else
  echo "⚠️ Grafana deployment not found."
fi

echo "⏳ Waiting for Grafana pod to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=grafana -n monitoring --timeout=90s || {
  echo "⚠️ Timed out waiting for Grafana pod readiness. Skipping port-forward."
  exit 1
}

echo "🔁 Attempting port-forward to Grafana..."
GRAFANA_SVC=$(kubectl get svc -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath="{.items[0].metadata.name}" 2>/dev/null || true)

if [[ -n "$GRAFANA_SVC" ]]; then
  kubectl -n monitoring port-forward svc/$GRAFANA_SVC 3000:80 > /tmp/grafana-port-forward.log 2>&1 &
  PORT_PID=$!
  sleep 2
  if grep -q "Forwarding from" /tmp/grafana-port-forward.log; then
    echo "✅ Grafana is accessible at http://localhost:3000"
  else
    echo "⚠️ Port-forward failed. Check /tmp/grafana-port-forward.log"
    kill $PORT_PID 2>/dev/null || true
  fi
else
  echo "⚠️ Grafana service not found."
fi