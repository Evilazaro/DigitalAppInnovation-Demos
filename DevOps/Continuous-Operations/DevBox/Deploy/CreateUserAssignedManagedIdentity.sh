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

# Download the preconfigured role definition example
aibRoleImageCreationOutput='./DownloadedFiles/aibRoleImageCreation-Output.json'
curl https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/aibRoleImageCreation-Template.json -o $aibRoleImageCreationOutput

imageRoleDefName="Contoso Azure Image Builder Image Def"

# Update the definition
sed -i -e "s%<subscriptionID>%$subscriptionID%g" $aibRoleImageCreationOutput
sed -i -e "s%<rgName>%$imageResourceGroup%g" $aibRoleImageCreationOutput
sed -i -e "s%Azure Image Builder Service Image Creation Role%$imageRoleDefName%g" $aibRoleImageCreationOutput

# Create role definitions
az role definition create --role-definition ./$aibRoleImageCreationOutput

# Grant a role definition to the user-assigned identity
az role assignment create \
    --assignee $imgBuilderCliId \
    --role "$imageRoleDefName" \
    --scope /subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup