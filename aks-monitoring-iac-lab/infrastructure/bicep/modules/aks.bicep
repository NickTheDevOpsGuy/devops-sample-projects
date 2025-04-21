param aksName string
param location string
param subnetId string
param environment string
param logAnalyticsWorkspaceId string = ''

resource aks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'aks-${environment}'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 2
        vmSize: 'Standard_B2ms'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        vnetSubnetID: subnetId
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
    }
    addonProfiles: empty(logAnalyticsWorkspaceId) ? {} : {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    }
  }
}
