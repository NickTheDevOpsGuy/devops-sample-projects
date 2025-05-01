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

## 📡 Sample App: Node Metrics Demo

This repo includes a sample Node.js application that exposes:

- `/` route for log testing (Loki)
- `/metrics` for Prometheus metric scraping via `prom-client`

It’s deployed into Kubernetes with Prometheus scrape annotations and used to populate dashboards automatically.

📁 See [`apps/node-metrics-demo/`](./apps/node-metrics-demo) for details.

---

## 📊 Dashboards Preview

Grafana auto-loads the following dashboards from ConfigMaps:

- ✅ Sample Node Metrics
- ✅ Pod Resource Usage
- ✅ Kubernetes Logs

All dashboards are defined in the `dashboards/` folder and automatically picked up by Grafana’s sidecar.

*(You could optionally include a screenshot or animated GIF here if you want to really show it off.)*

---

## ⚙️ CI/CD

This project includes GitHub Actions workflows for:

- ✅ Linting dashboard JSON files
- ✅ Deploying to AKS using `deploy.sh`

Workflows are located in `.github/workflows/` and run automatically on PRs and merges to `main`.

### 🔐 GitHub Secrets Required

| Secret Name         | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `AZURE_CREDENTIALS` | JSON string for Azure service principal (`az login` via GitHub Actions)     |
| `RESOURCE_GROUP`    | Azure Resource Group name for AKS (e.g. `NickClarkRG`)                      |


---

## 📁 Project Structure

```plaintext
devops-observability-stack/
├── .github/
│   ├── workflow/
│   │   └── deploy-aks.yaml
│   │   └── lint-dashboards.yaml
├── apps/
│   ├── node-metrics-demo/
│   │   └── deployment.yaml
│   │   └── Dockerfile
│   │   └── index.js
│   │   └── package.json
│   │   └── README.md
├── dashboards/
│   └── k8s-logs-dashboard.json
│   └── pod-resource-dashboard.json
│   └── sample-node-dashboard.json
├── environments/
│   ├── aks/
│   │   └── values-aks.yaml
│   └── minikube/
│       └── values-minikube.yaml
├── manifests/
│   ├── grafana/
│   │   └── k8s-logs-dashboard-configmap.yaml
│   │   └── pod-resource-dashboard-configmap.yaml
│   │   └── custom-dashboard-configmap.yaml
│   └── loki/
│       └── loki-pvc.yaml
│   ├── prometheus/
│   │   └── prometheus-service-monitor.yaml
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