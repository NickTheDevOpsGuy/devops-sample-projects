#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧼 Cleanup DevOps Observability Stack
# -----------------------------------------------------------------------------

function usage() {
  echo ""
  echo "🧼 Cleanup script for the DevOps Observability Stack"
  echo ""
  echo "Usage:"
  echo "  ./cleanup.sh --env <minikube|aks> [--help]"
  echo ""
  echo "Options:"
  echo "  --env     Target environment to clean up: 'minikube' or 'aks'"
  echo "  --help    Show this help message"
  echo ""
  echo "Example:"
  echo "  ./cleanup.sh --env minikube"
  echo ""
  exit 0
}

ENV=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --env)
      ENV="$2"
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

echo "🧹 Cleaning up environment: $ENV"

# -----------------------------------------------------------------------------
# 🛑 Kill port-forward processes (Grafana, Prometheus, etc.)
# -----------------------------------------------------------------------------

echo "🔌 Checking for port-forward processes on common ports..."

PORTS=(3000 9090 3100)  # Grafana, Prometheus, Loki
for PORT in "${PORTS[@]}"; do
  PID=$(lsof -ti tcp:$PORT || true)
  if [[ -n "$PID" ]]; then
    echo "⚠️  Port $PORT is in use by PID $PID. Killing it..."
    kill -9 "$PID" || true
  fi
done

# -----------------------------------------------------------------------------
# 🧹 Uninstall Helm releases
# -----------------------------------------------------------------------------

echo "💥 Uninstalling Helm releases..."
helm uninstall kube-prometheus -n monitoring || echo "⚠️ kube-prometheus not found"
helm uninstall loki -n monitoring || echo "⚠️ loki not found"

# -----------------------------------------------------------------------------
# 🧽 Delete namespace
# -----------------------------------------------------------------------------

echo "🧽 Deleting monitoring namespace..."
kubectl delete ns monitoring --ignore-not-found

echo "✅ Cleanup complete!"