#!/bin/bash

# This script is designed to fetch an image template, substitute placeholders with given variables, and then create and build an Azure image using the edited template.

# Echo the header.
echo "Creating Image"
echo "---------------"

# Retrieve the output file location from the first argument and print it.
echo "outputFile: $1"
outputFile=$1

# Retrieve and print the Azure subscription ID.
echo "subscriptionID: $2"
subscriptionID=$2

# Retrieve and print the Azure resource group name.
echo "imageResourceGroup: $3"
imageResourceGroup=$3

# Retrieve and print the Azure region/location.
echo "location: $4"
location=$4

# Retrieve and print the name of the image.
echo "imageName: $5"
imageName=$5

# Retrieve and print the identity name.
echo "identityName: $6"
identityName=$6

# Retrieve and print the image template file URL.
echo "imageTemplateFile: $7"
imageTemplateFile=$7
echo "---------------"

# Use 'curl' to download the image template from the given URL and save it to the specified output file location.
curl $imageTemplateFile -o $outputFile
echo "---------------"
echo "imageTemplateFile: $imageTemplateFile"
echo "outputFile: $outputFile"

# Use 'sed' to replace placeholders in the downloaded template file with the actual values provided as arguments to the script.
sed -i -e "s%<subscriptionID>%$subscriptionID%g" $outputFile
sed -i -e "s%<rgName>%$imageResourceGroup%g" $outputFile
sed -i -e "s%<region>%$location%g" $outputFile
sed -i -e "s%<imageName>%$imageName%g" $outputFile
sed -i -e "s%<identityName>%$identityName%g" $outputFile

# Create the image resource in Azure using the modified template file.
az resource create \
    --resource-group $imageResourceGroup \
    --properties @$outputFile \
    --is-full-object \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n $imageName

# Print the status.
echo "Building Image $imageName"

# Invoke the build action for the created image in Azure.
az resource invoke-action \
     --resource-group $imageResourceGroup \
     --resource-type  Microsoft.VirtualMachineImages/imageTemplates \
     -n $imageName \
     --action Run
