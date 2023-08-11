#!/bin/bash

echo "Creating VNet"
echo "-----------------"    
echo "resourceGroupName: $1"
resourceGroupName=$1
echo "location: $2"
location=$2
echo "vnetName: $3"
vnetName=$3
echo "subnetName: $4"
subnetName=$4
echo "-----------------"

az network vnet create \
    --resource-group $resourceGroupName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $subnetName \
    --subnet-prefix 10.0.1.0/24
