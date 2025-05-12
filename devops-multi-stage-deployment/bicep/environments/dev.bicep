param appName string

resource devSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${appName}/appsettings'
  properties: {
    LOG_LEVEL: 'debug'
    ENABLE_BETA_FEATURES: 'true'
    FEATURE_FLAGS__Experimental: 'true'
  }
}