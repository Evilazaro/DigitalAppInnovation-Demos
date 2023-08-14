#!/bin/bash

# This script creates a user-assigned managed identity and grants the "Owner" role to it at the subscription scope.

# Echo the header.
echo "Create a user-assigned managed identity and grant permissions"
echo "-------------------------------------------------------------"

# Retrieve and print the Azure resource group name.
echo "imageResourceGroup: $1"
imageResourceGroup=$1

# Retrieve and print the Azure subscription ID.
echo "subscriptionID: $2"
subscriptionID=$2

# Retrieve and print the identity ID.
echo "identityId: $3"
identityId=$3
echo "-------------------------------------------------------------"

# Use the Azure CLI to assign the "Owner" role to the provided identity ID. 
# This allows the identity to have full control over all resources in the subscription.
az role assignment create \
    --assignee $identityId \
    --role "Owner" \
    --scope /subscriptions/$subscriptionID
