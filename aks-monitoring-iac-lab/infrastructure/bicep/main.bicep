@description('Environment name (e.g., dev, prod)')
param environment string

@description('Location for resource deployment')
param location string = resourceGroup().location

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
  }
}

module grafana 'modules/grafana.bicep' = {
  name: 'grafana'
  params: {
    grafanaName: 'grafana-${environment}'
    location: location
  }
}

module flux 'modules/flux.bicep' = {
  name: 'flux'
  params: {
    fluxConfigName: 'flux-config'
    aksResourceId: aks.outputs.clusterName
    gitRepoUrl: 'https://github.com/NickTheDevOpsGuy/devops-sample-projects'
    gitBranch: 'develop'
    gitPath: './aks-monitoring-iac-lab/manifests'
  }
}

module defender 'modules/defender.bicep' = {
  name: 'defender'
  params: {
    planName: 'default'
  }
}