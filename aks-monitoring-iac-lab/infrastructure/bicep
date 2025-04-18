targetScope = 'resourceGroup'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the AKS cluster')
param aksName string = 'MyAKSCluster'

@description('Name of the Log Analytics workspace')
param workspaceName string = 'aks-monitoring-ws'

var dnsPrefix = toLower('\${aksName}-dns')

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  properties: { retentionInDays: 30 }
  sku: { name: 'PerGB2018' }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-09-01' = {
  name: aksName
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_D2s_v3'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalytics.id
        }
      }
    }
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...'
          }
        ]
      }
    }
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }
  }
  tags: { project: 'AKS-Monitoring-IaC' }
}

output aksClusterName string = aksCluster.name
output logAnalyticsWorkspaceId string = logAnalytics.id
