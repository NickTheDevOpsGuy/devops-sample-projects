#!/usr/bin/env bash
set -euo pipefail

RG="tfstate-rg"
SA="tfstateaccount"
CONTAINER="tfstate"

az group create --name $RG --location eastus
az storage account create --name $SA --resource-group $RG --location eastus --sku Standard_LRS
az storage container create --name $CONTAINER --account-name $SA