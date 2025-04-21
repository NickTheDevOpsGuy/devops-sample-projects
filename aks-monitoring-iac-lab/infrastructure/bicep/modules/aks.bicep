param location string
param subnetId string

resource aks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'nick-aks'
  location: location
  properties: {
    dnsPrefix: 'nickaks'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 2
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        vnetSubnetID: subnetId
      }
    ]
    addonProfiles: {
      azureMonitor: {
        enabled: true
      }
    }
    identity: {
      type: 'SystemAssigned'
    }
  }
}
