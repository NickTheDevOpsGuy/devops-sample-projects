targetScope = 'subscription'

param location string = 'eastus'
param rgName string = 'NickClarkRG'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module network 'modules/network.bicep' = {
  name: 'vnet'
  scope: rg
  params: {
    location: location
  }
}

module aks 'modules/aks.bicep' = {
  name: 'aks'
  scope: rg
  params: {
    location: location
    subnetId: network.outputs.subnetId
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  scope: rg
  params: {
    location: location
  }
}

module grafana 'modules/grafana.bicep' = {
  name: 'grafana'
  scope: rg
  params: {
    location: location
  }
}
