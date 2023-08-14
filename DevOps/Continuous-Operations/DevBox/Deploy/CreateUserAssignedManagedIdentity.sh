#!/bin/bash

echo "Create a user-assigned managed identity and grant permissions"
echo "-------------------------------------------------------------"   
echo "imageResourceGroup: $1"
imageResourceGroup=$1
echo "subscriptionID: $2"
subscriptionID=$2
echo "identityName: $3"
identityName=$3
echo "-------------------------------------------------------------"

# Grant a role definition to the user-assigned identity
az role assignment create \
    --assignee "/subscriptions/$subscriptionID/resourcegroups/$imageResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$identityName" \
    --role "Owner" \
    --scope /subscriptions/$subscriptionID