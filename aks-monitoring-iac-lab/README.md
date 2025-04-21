# 💻 AKS Monitoring Lab as IaC (Bicep)

Provision and monitor an AKS cluster end‑to‑end using infrastructure as code.  
You’ll deploy:

- A **Log Analytics** workspace  
- An **AKS** cluster with the **Container Insights** add‑on  
- A sample **NGINX** application to generate metrics & logs  
- (Optional) **Grafana** dashboards via Helm  

All resources are defined as **Bicep modules** (with a **Terraform** alternative), and helper scripts, manifests, tests, and CI/CD pipelines glue everything together.

---

## 📦 What’s Included

- ☸️ Azure Kubernetes Service (AKS)
- 📈 Azure Monitor with Managed Prometheus
- 📊 Azure Managed Grafana Dashboards
- 🧱 Modular Bicep Templates
- 🔁 GitOps with FluxCD
- 🛡 Defender for DevOps Integration
- 🚀 GitHub Actions CI Pipeline

## Repo & Files
```graphql
aks-monitoring-iac-lab/
├── .github/
│   └── workflows/
│       ├── ci.yaml
│       └── cd.yaml
├── docs/
│   └── architecture.md
├── flux-apps/
│   └── kustomizations.yaml
├── infrastructure/
│   ├── bicep/
│   │   └── modules/
│   │       ├── aks.bicep
│   │       └── grafana.bicep
│   │       └── log.bicep
│   │       └── monitoring.bicep
│   │       └── network.bicep
│   └── terraform/
│       ├── main.tf
│       └── README.md
│       └── variables.tf
├── manifests/
│   └── nginx-deployment.yaml
├── scripts/
│   ├── cleanup.sh
│   ├── deploy-app.sh
│   ├── deploy-infra.sh
│   └── cleanup.sh
├── tests/
│   ├── aks-connectivity-test.sh
│   ├── altert-smoke-query.sh
│   └── connectivity.sh
│   └── query-metrics.sh
├── .gitignore
├── LICENSE
├── README.md

```

## 🧱 Bicep Module Breakdown

Each part of the infrastructure is modularized:

| Module            | Description                                  |
|-------------------|----------------------------------------------|
| `network.bicep`   | Sets up VNet and AKS subnet                  |
| `aks.bicep`       | Deploys AKS with system-assigned identity    |
| `monitoring.bicep`| Creates Log Analytics + Prometheus alerts    |
| `grafana.bicep`   | Provisions Azure Managed Grafana             |



⚙️ Usage
✅ 1. Prerequisites

* Azure CLI logged in
* Subscription with Contributor access
* GitHub repo secrets set for AZURE_CREDENTIALS

▶️ 2. Deploy with Azure CLI

```bash
az deployment sub create \
  --location eastus \
  --template-file main.bicep \
  --parameters rgName=NickClarkRG
```

## 🛠 3. GitOps: Install Flux

```bash
az k8s-configuration flux create \
  --resource-group NickClarkRG \
  --cluster-name nick-aks \
  --name flux-config \
  --namespace flux-system \
  --cluster-type managedClusters \
  --scope cluster \
  --url https://github.com/NickTheDevOpsGuy/flux-apps \
  --branch main \
  --sync-interval 3m
```

## 📊 Dashboards

Azure Managed Grafana is deployed and accessible at:

| https://<grafana-name>.grafana.azure.com

You can import dashboards like:

* 🧠 Kubernetes Prometheus Dashboard – ID: 6417

Or create your own visualizations for:

* Node health
* CPU/memory usage
* Pod restarts
* Custom alerts

🔐 CI/CD & Security
GitHub Actions Workflow
Located at .github/workflows/deploy.yml, it handles:

* 🔁 Bicep deployment
* 🛡 CodeQL scanning
* 🔒 Defender for DevOps integration

## 🧠 Lessons Learned

* Modularizing Bicep enhances maintainability.
* Azure Managed Prometheus + Grafana provide robust observability.
* GitOps ensures consistent and auditable deployments.
* Defender for DevOps integrates security into the CI/CD pipeline.

## 🙌 Author

Nick Clark

* 🌐 LinkedIn
* 🐙 GitHub
* 🔖 #NickDoesDevOps