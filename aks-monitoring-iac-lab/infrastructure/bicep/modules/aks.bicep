param aksName string
param location string
param subnetId string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-01-02-preview' = {
  name: aksName
  location: location
  properties: {
    dnsPrefix: aksName
    enableRBAC: true
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
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
  }
}

output clusterName string = aksCluster.name
output aksResourceId string = aksCluster.id