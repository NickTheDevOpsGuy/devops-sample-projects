targetScope = 'subscription'

param location string
param planName string = 'DefenderForContainers'

module defender 'modules/defender.bicep' = {
  name: 'defender-sub'
  params: {
    location: location
    planName: planName
  }
}
