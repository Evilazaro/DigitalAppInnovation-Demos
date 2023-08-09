#!/bin/bash

./login.sh $1

echo "Setting Variables"
echo "-----------------"

# Resource group name - we're using myImageBuilderRG in this example
imageResourceGroup='ContosoImageBuilderRG'
# Region location 
location='EASTUS2'
# Run output name
runOutputName='ContosoWin11Image'
# The name of the image to be created
imageName='ContosoWin11Image'

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