@description('The name of the AKS cluster')
param aksName string

@description('Location for the AKS cluster')
param location string

@description('Subnet resource ID for AKS node pool')
param subnetId string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-05-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: '${aksName}-dns'
    kubernetesVersion: '' // Let Azure pick the latest GA version
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 1
        vmSize: 'Standard_B2ms'
        osType: 'Linux'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
        vnetSubnetId: subnetId
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      serviceCidr: '10.240.0.0/16'
      dnsServiceIP: '10.240.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
    enableRBAC: true
    sku: {
      name: 'Basic'
      tier: 'Free'
    }
  }
}

output clusterName string = aksCluster.name
output clusterResourceId string = aksCluster.id