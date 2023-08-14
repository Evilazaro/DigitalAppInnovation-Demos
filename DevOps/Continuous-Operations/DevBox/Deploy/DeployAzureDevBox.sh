#!/bin/bash

subscriptionId=$1
resourceGroupName="Contoso-AzureDevBox-rg"
location="EASTUS2"
vnetName="Contoso-AzureDevBox-vnet"
subnetName="Contoso-AzureDevBox-subnet"

az group create -n $resourceGroupName -l $location

./CreateVNet.sh $resourceGroupName $location $vnetName $subnetName

az devcenter admin network-connection create --location $location --domain-join-type "AzureADJoin" \ 
                                     --networking-resource-group-name $resourceGroupName \
                                     --subnet-id "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName" \
                                     --name "ContostoAzureDevBox-Vnet-Connection" --resource-group $resourceGroupName 