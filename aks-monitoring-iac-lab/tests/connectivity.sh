#!/usr/bin/env bash
set -euo pipefail

echo "🔌 Checking kubectl connectivity..."
kubectl get nodes --no-headers || { echo "ERROR: No nodes returned"; exit 1; }
echo "✅ kubectl can connect to cluster"
