@description('Location (not required for these resources but passed for consistency)')
param location string

@description('The name of the Defender plan to enable')
param planName string

resource defender 'Microsoft.Security/pricings@2023-01-01' = {
  name: planName
  properties: {
    pricingTier: 'Standard'
  }
}

resource autoProvision 'Microsoft.Security/autoProvisioningSettings@2023-01-01' = {
  name: 'default'
  properties: {
    autoProvision: 'On'
  }
}