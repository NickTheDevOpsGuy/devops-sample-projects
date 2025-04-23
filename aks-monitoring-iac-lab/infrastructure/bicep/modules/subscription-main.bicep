targetScope = 'subscription'

param location string = 'eastus'
param planName string = 'DefenderForContainers'

module defender 'modules/defender.bicep' = {
  name: 'defender-sub'
  params: {
    location: location
    planName: planName
  }
}