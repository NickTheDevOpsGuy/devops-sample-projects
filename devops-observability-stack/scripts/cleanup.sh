#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# 🧼 Cleanup DevOps Observability Stack
# -----------------------------------------------------------------------------

function usage() {
  echo ""
  echo "🧼 Clean up deployed observability stack"
  echo ""
  echo "Usage:"
  echo "  ./cleanup.sh --env <minikube|aks> [--help]"
  echo ""
  echo "Options:"
  echo "  --env     Target environment to clean: 'minikube' or 'aks'"
  echo "  --help    Show this help message"
  echo ""
  echo "Examples:"
  echo "  ./cleanup.sh --env minikube"
  echo "  ./cleanup.sh --env aks"
  echo ""
  exit 0
}

ENV=""

# Parse arguments
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
# Uninstall Helm releases and clean up namespace
# -----------------------------------------------------------------------------

echo "💥 Uninstalling Helm releases..."
helm uninstall kube-prometheus --namespace monitoring || echo "⚠️ kube-prometheus not found"
helm uninstall loki --namespace monitoring || echo "⚠️ loki not found"

echo "🧽 Deleting monitoring namespace..."
kubectl delete namespace monitoring --ignore-not-found

echo "🧼 Cleanup complete! ✅"