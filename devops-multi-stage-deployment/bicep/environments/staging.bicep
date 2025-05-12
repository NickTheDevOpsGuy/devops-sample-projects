param appName string
param appInsightsKey string

resource stagingSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${appName}/appsettings'
  properties: {
    LOG_LEVEL: 'info'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    STAGING_MODE: 'true'
  }
}