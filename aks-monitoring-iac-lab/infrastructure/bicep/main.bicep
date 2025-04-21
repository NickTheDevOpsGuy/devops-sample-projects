targetScope = 'resourceGroup'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'nick-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-05-01' = {
  name: 'NetworkWatcher_${resourceGroup().location}'
  location: resourceGroup().location
  properties: {}
}
