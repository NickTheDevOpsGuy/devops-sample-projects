targetScope = 'resourceGroup'

@description('Azure region, e.g. eastus')
param location      string = resourceGroup().location

@description('AKS cluster name')
param aksName       string = 'MyAKSCluster'

@description('Log Analytics workspace name')
param workspaceName string = 'aks-monitoring-ws'

// Deploy Log Analytics
module logWs 'modules/logAnalytics.bicep' = {
  name: 'deployLogAnalytics'
  params: { workspaceName: workspaceName }
}

// Deploy AKS cluster
module aksDeploy 'modules/aksCluster.bicep' = {
  name: 'deployAKSCluster'
  params: {
    aksName: aksName
    logAnalyticsWorkspaceId: logWs.outputs.workspaceId
  }
}

output aksClusterName          string = aksDeploy.outputs.aksClusterName
output logAnalyticsWorkspaceId string = logWs.outputs.workspaceId
