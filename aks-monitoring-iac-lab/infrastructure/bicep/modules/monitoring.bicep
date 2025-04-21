param location string = resourceGroup().location
param logAnalyticsName string = 'nick-law'
param workspaceRetention int = 30

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsName
  location: location
  properties: {
    retentionInDays: workspaceRetention
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource promWorkspace 'Microsoft.AlertsManagement/prometheusRuleGroups@2023-04-01-preview' = {
  name: 'nick-prometheus-rules'
  location: location
  properties: {
    enabled: true
    scopes: [
      logAnalytics.id
    ]
    evaluationFrequency: 'PT1M'
    ruleResolveConfiguration: {
      autoResolve: true
    }
    rules: [
      {
        name: 'HighCpuAlert'
        description: 'Alert on CPU > 90%'
        enabled: true
        condition: {
          metricName: 'container_cpu_usage_seconds_total'
          aggregation: 'Avg'
          operator: 'GreaterThan'
          threshold: 0.9
        }
        severity: 2
      }
    ]
  }
}

output logAnalyticsWorkspaceId string = logAnalytics.id
output logAnalyticsWorkspaceName string = logAnalytics.name
