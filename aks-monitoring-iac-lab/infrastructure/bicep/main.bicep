targetScope = 'resourceGroup'

param location string = resourceGroup().location
param environment string = 'dev'

module watcher 'modules/network-watcher.bicep' = {
  name: 'watcher'
  params: {
    location: location
  }
}

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
    environment: environment
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    environment: environment
  }
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  params: {
    location: location
    environment: environment
    aksName: 'aks-${environment}'
    subnetId: network.outputs.subnetId
    logAnalyticsWorkspaceId: monitoring.outputs.logAnalyticsWorkspaceId
  }
}