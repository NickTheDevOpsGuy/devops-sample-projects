@description('Name of the Azure Managed Grafana instance')
param grafanaName string
@description('Location for Grafana')
param location string
@description('Resource Group Name')
param resourceGroupName string
@description('Log Analytics Workspace Resource ID')
param workspaceResourceId string

resource grafana 'Microsoft.Dashboard/grafana@2022-08-01' = {
  name: grafanaName
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
    monitoring: {
      workspaceResourceId: workspaceResourceId
    }
  }
}

output grafanaUrl string = 'https://portal.azure.com/#resource${grafana.id}'