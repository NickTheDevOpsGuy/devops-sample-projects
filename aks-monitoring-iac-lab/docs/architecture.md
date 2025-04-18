# Architecture Overview

This lab provisions:

1. A **Log Analytics workspace** (`Microsoft.OperationalInsights/workspaces`).
2. An **AKS cluster** (`Microsoft.ContainerService/managedClusters`) with the **Container Insights** (omsagent) add‑on.

Resources are created via Bicep modules under `infrastructure/bicep/modules/`.  
Sample workloads and load‑generation live under `manifests/` and `scripts/`.
