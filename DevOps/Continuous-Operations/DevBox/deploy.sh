#!/bin/bash

./login.sh $1

echo "Setting Variables"
echo "-----------------"

# Resource group name - we're using myImageBuilderRG in this example
imageResourceGroup='Contoso-ImageBuilder-Base-Images-rg'
# Region location 
location='EASTUS2'
# Run output name
runOutputName='Win11EntBaseImageEngineers'
# The name of the image to be created
imageName='Win11EntBaseImageEngineers'

subscriptionID=$(az account show --query id --output tsv)

echo "imageResourceGroup: $imageResourceGroup"
echo "location: $location"
echo "runOutputName: $runOutputName"
echo "imageName: $imageName"
echo "Subscription ID: $subscriptionID"
echo "-----------------"

az group create -n $imageResourceGroup -l $location

./Register-Features.sh

./CreateUserAssignedManagedIdentity.sh  $imageResourceGroup $location $runOutputName $imageName $subscriptionID

./CreateImage.sh $imageResourceGroup $imageName