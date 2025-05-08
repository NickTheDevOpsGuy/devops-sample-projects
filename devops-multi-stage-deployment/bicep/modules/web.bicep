param location string
param appName string
param planId string

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: planId
    siteConfig: {
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/oss/python/python:3.11'
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://index.docker.io/v1/'
        }
      ]
    }
    httpsOnly: true
  }
}