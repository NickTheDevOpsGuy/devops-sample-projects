🧱 Quick Start: Deploy the VNet + Network Watcher
This project includes a simplified Bicep deployment that sets up a Virtual Network and Network Watcher inside a single Azure resource group.

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

## 📈 Coming Soon (Next Branches)

* 🔁 GitOps with FluxCD
* 📊 Azure Managed Grafana + Dashboards
* 🔐 Key Vault + OIDC Identity
* ⚙️ CI/CD via GitHub Actions
* 🌍 Multi-env separation (dev/stage/prod namespaces)
*🚀 Helm or Kustomize app deployment

## 👑 Part of the NickDoesDevOps Portfolio  
Follow more projects like this at [github.com/NickTheDevOpsGuy](https://github.com/NickTheDevOpsGuy)

> _World Domination, One Pipeline at a Time™_