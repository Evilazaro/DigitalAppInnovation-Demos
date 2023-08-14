#!/bin/bash

# This script creates a Virtual Network (VNet) and a subnet within that VNet in Azure.

# Print a header for clarity.
echo "Creating VNet"
echo "-----------------"

# Retrieve and print the Azure resource group name from the first argument.
echo "resourceGroupName: $1"
resourceGroupName=$1

# Retrieve and print the Azure region/location from the second argument.
echo "location: $2"
location=$2

# Retrieve and print the name of the Virtual Network from the third argument.
echo "vnetName: $3"
vnetName=$3

# Retrieve and print the name of the subnet from the fourth argument.
echo "subnetName: $4"
subnetName=$4
echo "-----------------"

# Use the Azure CLI to create the Virtual Network with a specified address prefix.
# Additionally, a subnet is also created within this VNet using a given subnet name and address prefix.
az network vnet create \
    --resource-group $resourceGroupName \
    --name $vnetName \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $subnetName \
    --subnet-prefix 10.0.1.0/24
