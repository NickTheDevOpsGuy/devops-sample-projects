@description('Name of the Log Analytics Workspace')
param workspaceName string

@description('Location for the workspace')
param location string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: 30
  }
}

output workspaceResourceId string = logAnalytics.id
output workspaceName string = logAnalytics.name