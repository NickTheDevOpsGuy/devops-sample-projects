param location string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'nick-law'
  location: location
  properties: {
    retentionInDays: 30
  }
}

output logAnalyticsId string = logAnalytics.id
