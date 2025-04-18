targetScope = 'resourceGroup'

@description('Azure region, e.g. eastus')
param location string = resourceGroup().location

@description('Name of the AKS cluster')
param aksName string = 'MyAKSCluster'

@description('Name of the Log Analytics workspace')
param workspaceName string = 'aks-monitoring-ws'

module logWs 'modules/logAnalytics.bicep' = {
  name: 'deployLogAnalytics'
  params: {
    workspaceName: workspaceName
  }
}

module aksDeploy 'modules/aksCluster.bicep' = {
  name: 'deployAKSCluster'
  params: {
    aksName: aksName
    logAnalyticsWorkspaceId: logWs.outputs.workspaceId
  }
}

output aksClusterName          string = aksDeploy.outputs.aksClusterName
output logAnalyticsWorkspaceId string = logWs.outputs.workspaceId
