@description('Environment name (e.g., dev, prod)')
param environment string

@description('Location for resource deployment')
param location string = resourceGroup().location

var shortHash = substring(uniqueString(resourceGroup().id), 0, 6)

module loganalytics 'modules/loganalytics.bicep' = {
  name: 'logAnalytics'
  params: {
    workspaceName: 'log-${environment}'
    location: location
  }
}

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    environment: environment
    location: location
  }
}

module networkWatcher 'modules/network-watcher.bicep' = {
  name: 'networkWatcher'
  params: {
    location: location
  }
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  params: {
    aksName: 'aks-${environment}'
    subnetId: network.outputs.subnetId
    location: location
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    environment: environment
    location: location
    workspaceResourceId: loganalytics.outputs.workspaceResourceId
    workspaceName: loganalytics.outputs.workspaceName
  }
}

module grafana 'modules/grafana.bicep' = {
  name: 'grafana'
  params: {
    grafanaName: 'grafana-${environment}-${shortHash}'
    location: location
    resourceGroupName: resourceGroup().name
    environment: environment
    workspaceResourceId: loganalytics.outputs.workspaceResourceId
  }
}