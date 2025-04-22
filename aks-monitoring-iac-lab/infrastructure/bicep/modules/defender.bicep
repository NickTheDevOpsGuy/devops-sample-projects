@description('Plan name for Defender')
param planName string = 'default'

resource defender 'Microsoft.Security/pricings@2022-01-01-preview' = {
  name: 'ContainerRegistry'
  properties: {
    pricingTier: 'Standard'
  }
}

resource autoProvision 'Microsoft.Security/autoProvisioningSettings@2022-01-01-preview' = {
  name: planName
  properties: {
    autoProvision: 'On'
  }
}