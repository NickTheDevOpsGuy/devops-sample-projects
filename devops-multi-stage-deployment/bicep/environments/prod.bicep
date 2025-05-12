param appName string
param keyVaultUri string
param appInsightsKey string

resource prodSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${appName}/appsettings'
  properties: {
    LOG_LEVEL: 'error'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    KEYVAULT_URI: keyVaultUri
    FEATURE_FLAGS__Experimental: 'false'
  }
}