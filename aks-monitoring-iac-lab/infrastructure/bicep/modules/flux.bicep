@description('Flux configuration name')
param fluxConfigName string

@description('AKS cluster name (not full resource ID)')
param aksResourceId string

@description('Git repository URL')
param gitRepoUrl string

@description('Git branch')
param gitBranch string = 'main'

@description('Path to manifests in the repo')
param gitPath string = './manifests'

resource aks 'Microsoft.ContainerService/managedClusters@2023-01-02-preview' existing = {
  name: aksResourceId
}

resource fluxConfig 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01' = {
  name: fluxConfigName
  scope: aks
  properties: {
    scope: 'cluster'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    gitRepository: {
      url: gitRepoUrl
      repositoryRef: {
        branch: gitBranch
      }
      syncIntervalInSeconds: 60
      timeoutInSeconds: 600
    }
    kustomizations: {
      fluxSystem: {
        path: gitPath
        syncIntervalInSeconds: 60
        prune: true
        retryIntervalInSeconds: 600
      }
    }
  }
}