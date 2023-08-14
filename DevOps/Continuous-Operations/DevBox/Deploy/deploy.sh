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
identityId=$(az identity show --resource-group $imageResourceGroup -n $identityName --query principalId --output tsv)

echo "imageResourceGroup: $imageResourceGroup"
echo "location: $location"
echo "Subscription ID: $subscriptionID"
echo "Identity Name: $identityName"
echo "Identity ID: $identityId"
echo "-----------------"

./Register-Features.sh

./CreateUserAssignedManagedIdentity.sh $imageResourceGroup $subscriptionID $identityId

imageName='Win11EntBaseImageFrontEndEngineers'
echo "Creating Image $imageName"
imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-FrontEnd-Template.json
outputFile='./DownloadedFiles/Win11-Ent-Base-Image-FrontEnd-Template-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $identityName $imageTemplateFile

imageName='Win11EntBaseImageBackEndEngineers'
echo "Creating Image $imageName"
imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-BackEnd-Template.json
outputFile='./DownloadedFiles/Win11-Ent-Base-Image-FrontEnd-Template-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $identityName $imageTemplateFile