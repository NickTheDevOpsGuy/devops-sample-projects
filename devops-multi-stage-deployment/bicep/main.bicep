param location string = resourceGroup().location
param appInsightsKey string = ''
param keyVaultUri string = ''

// Shared App Service Plan
module plan './modules/plan.bicep' = {
  name: 'appServicePlan'
  params: {
    location: location
    sku: 'P1v2'
    planName: 'devopsDemoPlan'
  }
}

// ──────── DEV ────────
module dev './modules/webapp.bicep' = {
  name: 'webAppDev'
  params: {
    location: location
    appName: 'devops-demo-app-dev'
    planId: plan.outputs.planId
  }
}

module devConfig './environments/dev.bicep' = {
  name: 'envConfigDev'
  params: {
    appName: 'devops-demo-app-dev'
  }
}

// ──────── STAGING ────────
module staging './modules/webapp.bicep' = {
  name: 'webAppStaging'
  params: {
    location: location
    appName: 'devops-demo-app-staging'
    planId: plan.outputs.planId
  }
}

module stagingConfig './environments/staging.bicep' = {
  name: 'envConfigStaging'
  params: {
    appName: 'devops-demo-app-staging'
    appInsightsKey: appInsightsKey
  }
}

// ──────── PROD ────────
module prod './modules/webapp.bicep' = {
  name: 'webAppProd'
  params: {
    location: location
    appName: 'devops-demo-app-prod'
    planId: plan.outputs.planId
  }
}

module prodConfig './environments/prod.bicep' = {
  name: 'envConfigProd'
  params: {
    appName: 'devops-demo-app-prod'
    appInsightsKey: appInsightsKey
    keyVaultUri: keyVaultUri
  }
}