@description('Name of the Defender plan')
param planName string = 'default'
@description('Location')
param location string
@description('AKS Resource ID')
param aksResourceId string

resource defender 'Microsoft.Security/pricings@2022-01-01-preview' = {
  name: 'ContainerRegistry'
  properties: {
    pricingTier: 'Standard'
  }
}

resource k8sDefender 'Microsoft.Security/autoProvisioningSettings@2022-01-01-preview' = {
  name: planName
  properties: {
    autoProvision: 'On'
  }
}