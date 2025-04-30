# 📊 DevOps Observability Stack
![Kubernetes](https://img.shields.io/badge/platform-kubernetes-blue)
![Helm](https://img.shields.io/badge/helm-chart-success)
![CI Ready](https://img.shields.io/badge/deploy-minikube%20%7C%20aks-green)

An end-to-end observability stack for Kubernetes featuring:

- 📈 **Prometheus** for metrics
- 📦 **Loki** for log aggregation
- 📊 **Grafana** for dashboards (auto-deployed via Loki chart)

Supports deployment to:

- 🐳 **Minikube** (local)
- ☁️ **Azure Kubernetes Service (AKS)**

---

## 📁 Project Structure

```plaintext
devops-observability-stack/
├── dashboards/
│   └── sample-node-dashboard.json
├── environments/
│   ├── aks/
│   │   └── values-aks.yaml
│   └── minikube/
│       └── values-minikube.yaml
├── manifests/
│   ├── prometheus/
│   │   └── prometheus-service-monitor.yaml
│   ├── grafana/
│   │   └── custom-dashboard-configmap.yaml
│   └── loki/
│       └── loki-pvc.yaml
├── scripts/
│   ├── deploy.sh
│   └── cleanup.sh
└── README.md
```

---

## 🚀 Getting Started

### 🔧 Requirements

- `kubectl`
- `helm`
- `az` CLI (for AKS)
- `minikube` (for local testing)

---

## 🛠️ Deployment

🔁 Minikube

```bash
./scripts/deploy.sh --env minikube
```

☁️ AKS
```bash
./scripts/deploy.sh --env aks --resource-group <your-resource-group>
```

After deployment, Grafana will be available at:

```bash
http://localhost:3000
```

(Port-forwarding starts automatically if the Grafana service is detected.)


## 📦 Components

| Tool         | Role                                | Deployed Via               | Access                     |
|--------------|-------------------------------------|----------------------------|----------------------------|
| **Prometheus** | Metrics collection (nodes, pods)     | `kube-prometheus-stack` Helm chart | Manual port-forward (optional) |
| **Loki**       | Centralized log aggregation         | `loki-stack` Helm chart (includes Grafana) | n/a (integrated into Grafana)  |
| **Grafana**    | Dashboards for metrics + logs       | Bundled in `loki-stack`    | http://localhost:3000 |

---

## 🧼 Cleanup

```bash
./scripts/cleanup.sh --env minikube
# or
./scripts/cleanup.sh --env aks
```

This will uninstall all Helm releases and delete the monitoring namespace.

## 🤘 Credits

Built with ❤️ by [NickDoesDevOps](https://github.com/NickTheDevOpsGuy)