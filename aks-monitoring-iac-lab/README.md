# ☁️ AKS Monitoring IaC Lab

This project provisions a production-grade Azure Kubernetes Service (AKS) cluster with full observability and GitOps automation using Bicep and Azure-native tools.

---

## 🧱 Infrastructure as Code

All infrastructure is defined using modular [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) templates located in the `infrastructure/` folder.

## 📦 Folder Structure (Relevant Parts)

```graphql
aks-monitoring-iac-lab/
├── infrastructure/
│   └── bicep/
│       ├── main.bicep
│       ├── parameters.dev.json
│       └── modules/
│           ├── aks.bicep
│           ├── monitoring.bicep
│           ├── network-watcher.bicep
│           └── network.bicep
│           └── flux.bicep
│           └── grafana.bicep
│           └── defender.bicep
├── scripts/
│   ├── deploy.sh
│   └── cleanup.sh
├── .gitignore
├── LICENSE
├── README.md

```

## 🚀 Deploy It

```~~bash~~
./deploy.sh <resource-group-name> [location]
```

Example:

```bash
./deploy.sh NickClarkRG eastus
```

This will:

* ✅ Create the resource group (if it doesn’t exist)
* 🧱 Deploy a VNet and subnet
* 🔍 Deploy Azure Network Watcher into the same resource group
* 🧠 Avoid auto-created NetworkWatcherRG_* resource groups

## 🧹 How to Clean Up
``bash
./cleanup.sh NickClarkRG
```
Prompts you to confirm deletion before destroying everything inside the resource group.

## 🆘 Help

```bash
./deploy.sh -h
```
Displays usage instructions with emoji prompts 💬

## 📥 Prerequisites

* Logged in with Azure CLI: az login
* Subscription access with permission to deploy resources
* Azure CLI version 2.30+ (for Bicep support)

## 🧠 Current Features

* ✅ Modular Bicep architecture
* ✅ Per-environment parameter support (dev, prod, etc.)
* ✅ Clean deploy/cleanup CLI scripts with emoji prompts
* ✅ Linked AKS to Log Analytics
* ✅ Automatic kubeconfig setup after deploy

## 📍 Roadmap
* ✅ Modularized Bicep for AKS, Network, Monitoring
* ✅ Deployment automation via Bash scripts
* ✅ manifests/ folder added for GitOps app deployment
*  🚧 Add modules for Grafana, FluxCD, Defender (in progress on feature/add-grafana-flux-defender-modules)
*  🔜 Set up GitHub Actions CI to deploy infra + manifests
*  🔜 Add multi-environment support (dev/stage/prod)

## 🧠 Learn More

| 🔍 Topic                        | 📚 Documentation / Resource                                                                 |
|-------------------------------|---------------------------------------------------------------------------------------------|
| Azure Bicep                   | [What is Bicep?](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) |
| Azure Kubernetes Service (AKS)| [AKS Overview](https://learn.microsoft.com/en-us/azure/aks/)                                |
| Azure Monitor                 | [Monitoring AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview) |
| Azure Managed Grafana         | [Managed Grafana Overview](https://learn.microsoft.com/en-us/azure/managed-grafana/overview) |
| FluxCD (GitOps)               | [Flux Documentation](https://fluxcd.io/docs/)                                               |
| GitOps on Azure               | [Use GitOps with AKS](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2) |
| Defender for Containers       | [Defender for Containers Overview](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-introduction) |
| Azure Network Watcher         | [Azure Network Watcher Docs](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview) |
| Infrastructure as Code (IaC)  | [IaC with Azure](https://learn.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/infrastructure-as-code) |

## 👑 Part of the NickDoesDevOps Portfolio  
Follow more projects like this at [github.com/NickTheDevOpsGuy](https://github.com/NickTheDevOpsGuy)

> _World Domination, One Pipeline at a Time™_