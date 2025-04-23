@description('Environment name')
param environment string

@description('Location for deployment')
param location string

@description('Log Analytics workspace resource ID')
param workspaceResourceId string

@description('Log Analytics workspace name')
param workspaceName string

resource containerInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'insights-${environment}'
  location: location
  kind: 'other'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceResourceId
  }
}