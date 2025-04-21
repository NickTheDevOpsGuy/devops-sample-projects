targetScope = 'resourceGroup'

param location string = resourceGroup().location
param environment string
param aksName string
param workspaceName string

module network 'modules/network.bicep' = {
  name: 'network'
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
    aksName: aksName
    subnetId: network.outputs.subnetId
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    environment: environment
    workspaceName: workspaceName
  }
}

module grafana 'modules/grafana.bicep' = {
  name: 'grafana'
  params: {
    location: location
    environment: environment
  }
}
