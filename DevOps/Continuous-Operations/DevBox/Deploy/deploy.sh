#!/bin/bash

# This script logs into Azure, sets up resource groups, and creates images using given templates.

# Run the login script with the first argument passed to this script.
./login.sh $1

# Echoing the progress.
echo "Setting Variables"
echo "-----------------"

# Define the resource group name. 
imageResourceGroup='Contoso-Base-Images-Engineers-rg'

# Define the Azure region where resources will be deployed.
location='WestUS3'

# Define the identity name for image builder.
identityName=contosoIdentityIBuilderUserDevBox

# Fetch the subscription ID for the logged-in account.
subscriptionID=$(az account show --query id --output tsv)

# Create the resource group in the specified location.
az group create -n $imageResourceGroup -l $location

# Create a new managed identity within the defined resource group.
az identity create --resource-group $imageResourceGroup -n $identityName

# Fetch the principal ID of the newly created managed identity.
identityId=$(az identity show --resource-group $imageResourceGroup -n $identityName --query principalId --output tsv)

# Print out the values for verification.
echo "imageResourceGroup: $imageResourceGroup"
echo "location: $location"
echo "Subscription ID: $subscriptionID"
echo "Identity Name: $identityName"
echo "Identity ID: $identityId"
echo "-----------------"

# Run the script to register necessary features.
./Register-Features.sh

# Run the script to create a user-assigned managed identity using the specified arguments.
./CreateUserAssignedManagedIdentity.sh $imageResourceGroup $subscriptionID $identityId

# Setting up variables for the front-end image and then invoking the image creation script.
imageName='Win11EntBaseImageFrontEndEngineers'
echo "Creating Image $imageName"
imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-FrontEnd-Template.json
outputFile='./DownloadedFiles/Win11-Ent-Base-Image-FrontEnd-Template-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $identityName $imageTemplateFile

clear

# Setting up variables for the back-end image and then invoking the image creation script.
imageName='Win11EntBaseImageBackEndEngineers'
echo "Creating Image $imageName"
imageTemplateFile=https://raw.githubusercontent.com/Evilazaro/DigitalAppInnovation-Demos/main/DevOps/Continuous-Operations/DevBox/Deploy/Win11-Ent-Base-Image-BackEnd-Template.json
outputFile='./DownloadedFiles/Win11-Ent-Base-Image-BackEnd-Template-Output.json'
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

./CreateImage.sh $outputFile $subscriptionID $imageResourceGroup $location $imageName $identityName $imageTemplateFile
