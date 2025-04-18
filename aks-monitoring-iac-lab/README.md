# 💻 AKS Monitoring Lab as IaC (Bicep)

Deploy your entire AKS monitoring stack—including Log Analytics and the AKS cluster with Container Insights—using a single Bicep template. You’ll then connect, verify, and deploy a sample app.

---

## 1. Objective
- Provision a **Log Analytics** workspace  
- Deploy an **AKS** cluster with the **monitoring** addon enabled  
- Connect via `kubectl` and verify node readiness  
- Deploy a sample **NGINX** app and generate load  
- Query **node_cpu_usage_percentage** via CLI  
- (Bonus) Install **Grafana** with Helm

## 2. Prerequisites
- Azure CLI & Bicep
- kubectl
- Helm 3
- Contributor access to an Azure subscription
- Resource Group: `YourOwnResourceGroupName`

## 3. Repo & Files
```graphql
aks-monitoring-iac-lab/
├── .github/
│   └── workflows/
│       ├── ci.yaml            # Lint/Bicep validate + test connectivity
│       └── cd.yaml            # Deploy infra → smoke tests
├── infrastructure/
│   ├── bicep/                 
│   │   ├── modules/           
│   │   │   ├── logAnalytics.bicep
│   │   │   └── aksCluster.bicep
│   │   ├── main.bicep         # Imports modules
│   │   ├── parameters.dev.json
│   │   └── parameters.prod.json
│   └── terraform/             # (Optional) if you want Terraform parity
│       ├── modules/
│       ├── main.tf
│       └── variables.tf
├── manifests/
│   └── nginx-deployment.yaml
├── scripts/
│   ├── deploy-infra.sh        # Wraps az deployment group create
│   ├── deploy-app.sh          # kubectl apply + expose
│   ├── query-metrics.sh       # CLI queries for node_cpu_usage_percentage :contentReference[oaicite:1]{index=1}
│   ├── create-alert.sh
│   └── cleanup.sh
├── tests/
│   ├── connectivity.sh        # e.g. `kubectl get nodes` + exit code check
│   ├── metrics-query.sh       # Run az monitor metrics list -> assert output
│   └── alert-smoke.sh         # Validate `az monitor metrics alert list`
├── docs/
│   └── architecture.md
├── .gitignore
├── LICENSE
└── README.md
```

## 4. Write the Bicep Template

Create main.bicep:

```bicep
targetScope = 'resourceGroup'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the AKS cluster')
param aksName string = 'MyAKSCluster'

@description('Name of the Log Analytics workspace')
param workspaceName string = 'aks-monitoring-ws'

var dnsPrefix = toLower('${aksName}-dns')

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: 30
  }
  sku: {
    name: 'PerGB2018'
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-09-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_D2s_v3'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalytics.id
        }
      }
    }
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...' 
          }
        ]
      }
    }
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }
  }
  tags: {
    project: 'AKS-Monitoring-IaC'
  }
}

output aksClusterName string = aksCluster.name
output logAnalyticsWorkspaceId string = logAnalytics.id
```

| Note: Replace the SSH public key in ssh-rsa … with your own.

Optionally create parameters.json to override defaults:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "aksName": { "value": "MyAKSCluster" },
    "workspaceName": { "value": "aks-monitoring-ws" },
    "location": { "value": "eastus" }
  }
}
```

## 5. Deploy via Bicep

1. Log in & set RG

```bash
az login
az account set --subscription "<Your-Subscription-ID>"
az group create --name YourOwnResourceGroupName --location eastus
```

2. Deploy

```bash
az deployment group create \
  --resource-group YourOwnResourceGroupName \
  --template-file main.bicep \
  --parameters @parameters.json
```

3. Capture outputs

```bash
export CLUSTER_NAME=$(az deployment group show \
  --resource-group YourOwnResourceGroupName \
  --name main \
  --query properties.outputs.aksClusterName.value -o tsv)
export WORKSPACE_ID=$(az deployment group show \
  --resource-group YourOwnResourceGroupName \
  --name main \
  --query properties.outputs.logAnalyticsWorkspaceId.value -o tsv)
```

4. Connect & Verify

```bash
az aks get-credentials \
  --resource-group YourOwnResourceGroupName \
  --name $CLUSTER_NAME \
  --overwrite-existing

kubectl get nodes
```
You should see 2 nodes in Ready state.

## 6. Deploy Sample App & Generate Load

1. Create nginx-deployment.yaml (in the same folder):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-lab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-lab
  template:
    metadata:
      labels:
        app: nginx-lab
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 80
```

2. Deploy & expose

```bash
kubectl apply -f nginx-deployment.yaml
kubectl expose deployment nginx-lab --port=80 --type=LoadBalancer
```

3. Wait for EXTERNAL‑IP

```bash
kubectl get svc nginx-lab --watch
```

4. Generate traffic

```bash
kubectl run -i --tty load-gen --rm --image=busybox -- /bin/sh
while true; do wget -q -O- http://<EXTERNAL-IP>; done
```

## 8. Query Metrics & Logs

* Node CPU %

```bash
az monitor metrics list \
  --resource "/subscriptions/<SubID>/resourceGroups/NickClarkRG/providers/Microsoft.ContainerService/managedClusters/$CLUSTER_NAME" \
  --metric "node_cpu_usage_percentage" \
  --interval PT1M
```

* Container logs (Kusto)

```bash
az monitor log-analytics query \
  --workspace "$WORKSPACE_ID" \
  --analytics-query "ContainerLog | where Image contains 'nginx' | take 20"
```

## 9. (Optional) Install Grafana with Helm

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install kube-prom prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace

helm install aks-graf grafana/grafana \
  --namespace monitoring \
  --set adminUser=admin,adminPassword='YourP@ssw0rd'

kubectl port-forward svc/aks-graf 3000:80 -n monitoring
# Browse http://localhost:3000 (admin/admin)
```

## 10. Cleanup resources

```bash
az group delete --name YourOwnResourceGroupName --yes --no-wait
```
