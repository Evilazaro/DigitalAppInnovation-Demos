#!/bin/bash

echo "Create a user-assigned managed identity and grant permissions"
echo "-------------------------------------------------------------"   
echo "imageResourceGroup: $1"
imageResourceGroup=$1
echo "location: $2"
location=$2
echo "runOutputName: $3"
runOutputName=$3
echo "imageName: $4"
imageName=$4
echo "subscriptionID: $5"
subscriptionID=$5
echo "-------------------------------------------------------------"

identityName=contosoIdentityIBuilderUser
az identity create --resource-group $imageResourceGroup -n $identityName

# Get the identity ID
imgBuilderCliId=$(az identity show -g $imageResourceGroup -n $identityName --query clientId -o tsv)

# Get the user identity URI that's needed for the template
imgBuilderId=/subscriptions/$subscriptionID/resourcegroups/$imageResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$identityName

# Download the preconfigured role definition example
curl https://raw.githubusercontent.com/Evilazaro/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json -o aibRoleImageCreation.json

imageRoleDefName="Contoso Azure Image Builder Image Def"

# Update the definition
sed -i -e "s%<subscriptionID>%$subscriptionID%g" aibRoleImageCreation.json
sed -i -e "s%<rgName>%$imageResourceGroup%g" aibRoleImageCreation.json
sed -i -e "s%Azure Image Builder Service Image Creation Role%$imageRoleDefName%g" aibRoleImageCreation.json

# Create role definitions
az role definition create --role-definition ./aibRoleImageCreation.json

# Grant a role definition to the user-assigned identity
az role assignment create \
    --assignee $imgBuilderCliId \
    --role "$imageRoleDefName" \
    --scope /subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup

echo "Download the image configuration template"

curl https://raw.githubusercontent.com/Evilazaro/azvmimagebuilder/master/quickquickstarts/0_Creating_a_Custom_Windows_Managed_Image/Win11-Ent-Base-Image-Engineers.json -o Win11-Ent-Base-Image-Engineers.json

sed -i -e "s%<subscriptionID>%$subscriptionID%g" Win11-Ent-Base-Image-Engineers.json
sed -i -e "s%<rgName>%$imageResourceGroup%g" Win11-Ent-Base-Image-Engineers.json
sed -i -e "s%<region>%$location%g" Win11-Ent-Base-Image-Engineers.json
sed -i -e "s%<imageName>%$imageName%g" Win11-Ent-Base-Image-Engineers.json
sed -i -e "s%<runOutputName>%$runOutputName%g" Win11-Ent-Base-Image-Engineers.json
sed -i -e "s%<imgBuilderId>%$imgBuilderId%g" Win11-Ent-Base-Image-Engineers.json





