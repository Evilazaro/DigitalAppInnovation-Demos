#!/bin/bash

./login.sh $1

echo "Setting Variables"
echo "-----------------"

# Resource group name - we're using myImageBuilderRG in this example
imageResourceGroup='Contoso-ImageBuilder-Base-Images-Engineers-rg'
# Region location 
location='EASTUS2'
# Run output name
runOutputName='runOutputManagedImage'
# The name of the image to be created
imageName='Win11EntBaseImageEngineers'
identityName=contosoIdentityIBuilderUser
subscriptionID=$(az account show --query id --output tsv)

az group create -n $imageResourceGroup -l $location
az identity create --resource-group $imageResourceGroup -n $identityName

# Get the identity ID
imgBuilderCliId=$(az identity show -g $imageResourceGroup -n $identityName --query clientId -o tsv)
# Get the user identity URI that's needed for the template
imgBuilderId=/subscriptions/$subscriptionID/resourcegroups/$imageResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$identityName
aibRoleImageCreation='aibRoleImageCreation.json'

echo "imageResourceGroup: $imageResourceGroup"
echo "location: $location"
echo "runOutputName: $runOutputName"
echo "imageName: $imageName"
echo "Subscription ID: $subscriptionID"
echo "Identity Name: $identityName"
echo "Identity Client ID: $imgBuilderCliId"
echo "Identity ID: $imgBuilderId"
echo "-----------------"

./Register-Features.sh

./CreateUserAssignedManagedIdentity.sh $imageResourceGroup $subscriptionID $imgBuilderCliId

echo "Creating Image"
imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-Engineers-Template.json
outputFile='Win11-Ent-Base-Image-Engineers-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $runOutputName $imgBuilderId $imageTemplateFile


imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-Engineers-Template.json
outputFile='Win11-Ent-Base-Image-Engineers-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $runOutputName $imgBuilderId $imageTemplateFile