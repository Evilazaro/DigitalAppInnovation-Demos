#!/bin/bash

# This script automates the creation of an Azure Resource Group, a Virtual Network (VNet) inside that Resource Group, 
# and sets up a network connection for Azure Development Center with domain-join capabilities.

# Set the Azure subscription ID from the first argument.
subscriptionId=$1

# Define fixed variables for the resource group, location, virtual network, and subnet names.
resourceGroupName="Contoso-AzureDevBox-rg"
location="EASTUS2"
vnetName="Contoso-AzureDevBox-vnet"
subnetName="Contoso-AzureDevBox-subnet"

# Create a new resource group using the Azure CLI.
az group create -n $resourceGroupName -l $location

# Call an external script (CreateVNet.sh) to create the Virtual Network and subnet.
./CreateVNet.sh $resourceGroupName $location $vnetName $subnetName

# Create a network connection for Azure Development Center.
# This connection enables Azure AD domain-join capabilities for VMs in the specified VNet and subnet.
az devcenter admin network-connection create \
    --location $location \
    --domain-join-type "AzureADJoin" \
    --networking-resource-group-name $resourceGroupName \
    --subnet-id "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName" \
    --name "ContostoAzureDevBox-Vnet-Connection" \
    --resource-group $resourceGroupName 
