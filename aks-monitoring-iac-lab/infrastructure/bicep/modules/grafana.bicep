param location string

resource grafana 'Microsoft.Dashboard/grafana@2022-08-01' = {
  name: 'nick-grafana'
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

output grafanaUrl string = 'https://${grafana.name}.grafana.azure.com'
