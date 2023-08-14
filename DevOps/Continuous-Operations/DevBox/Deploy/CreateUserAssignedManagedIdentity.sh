#!/bin/bash

echo "Create a user-assigned managed identity and grant permissions"
echo "-------------------------------------------------------------"   
echo "imageResourceGroup: $1"
imageResourceGroup=$1
echo "subscriptionID: $2"
subscriptionID=$2
echo "identityId: $3"
identityId=$3
echo "-------------------------------------------------------------"

# Grant a role definition to the user-assigned identity
az role assignment create \
    --assignee $identityId \
    --role "Owner" \
    --scope /subscriptions/$subscriptionID