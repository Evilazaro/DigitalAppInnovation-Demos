#!/bin/bash

echo "Create a user-assigned managed identity and grant permissions"
echo "-------------------------------------------------------------"   
echo "imageResourceGroup: $1"
imageResourceGroup=$1
echo "subscriptionID: $2"
subscriptionID=$2
echo "imgBuilderCliId: $3"
imgBuilderCliId=$3
echo "-------------------------------------------------------------"

# Grant a role definition to the user-assigned identity
az role assignment create \
    --assignee $imgBuilderCliId \
    --role "Owner" \
    --scope /subscriptions/$subscriptionID