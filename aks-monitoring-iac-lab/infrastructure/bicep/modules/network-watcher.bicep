@description('Deployment location')
param location string

resource networkWatcher 'Microsoft.Network/networkWatchers@2022-05-01' = {
  name: 'NetworkWatcher_${location}'
  location: location
  properties: {}
}
