#!/bin/bash

./login.sh $1

echo "Setting Variables"
echo "-----------------"

# Resource group name - we're using myImageBuilderRG in this example
imageResourceGroup='Contoso-Base-Images-Engineers-rg'
# Region location 
location='WestUS3'
identityName=contosoIdentityIBuilderUserDevBox
subscriptionID=$(az account show --query id --output tsv)

az group create -n $imageResourceGroup -l $location
az identity create --resource-group $imageResourceGroup -n $identityName

aibRoleImageCreation='aibRoleImageCreation.json'

echo "imageResourceGroup: $imageResourceGroup"
echo "location: $location"
echo "Subscription ID: $subscriptionID"
echo "Identity Name: $identityName"
echo "Identity ID: $imgBuilderId"
echo "-----------------"

./Register-Features.sh

./CreateUserAssignedManagedIdentity.sh $imageResourceGroup $subscriptionID $

imageName='Win11EntBaseImageFrontEndEngineers'
echo "Creating Image $imageName"
imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-FrontEnd-Template.json
outputFile='./DownloadedFiles/Win11-Ent-Base-Image-FrontEnd-Template-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $identityName $imageTemplateFile