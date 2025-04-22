@description('Flux extension name')
param extensionName string = 'flux'
@description('AKS cluster name')
param aksClusterName string
@description('AKS cluster RG')
param aksResourceGroup string
@description('Location')
param location string

resource flux 'Microsoft.KubernetesConfiguration/extensions@2022-11-01' = {
  name: '${aksClusterName}/${extensionName}'
  scope: resourceGroup(aksResourceGroup)
  location: location
  properties: {
    extensionType: 'microsoft.flux'
    autoUpgradeMinorVersion: true
    releaseTrain: 'Stable'
    scope: {
      cluster: {
        releaseNamespace: 'flux-system'
      }
    }
  }
}