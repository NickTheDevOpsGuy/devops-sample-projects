@description('Grafana instance name')
param grafanaName string

@description('Location')
param location string

resource grafana 'Microsoft.Dashboard/grafana@2022-08-01' = {
  name: grafanaName
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}