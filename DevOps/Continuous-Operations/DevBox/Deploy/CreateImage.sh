#!/bin/bash
echo "Creating Image"
echo "---------------"
echo "outputFile: $1"
outputFile=$1
echo "subscriptionID: $2"
subscriptionID=$2
echo "imageResourceGroup: $3"
imageResourceGroup=$3
echo "location: $4"
location=$4
echo "imageName: $5"
imageName=$5
echo "identityName: $6"
identityName=$6
echo "imageTemplateFile: $7"
imageTemplateFile=$7
echo "---------------"

curl $imageTemplateFile -o $outputFile
echo "---------------"
echo "imageTemplateFile: $imageTemplateFile"

sed -i -e "s%<subscriptionID>%$subscriptionID%g" $outputFile
sed -i -e "s%<rgName>%$imageResourceGroup%g" $outputFile
sed -i -e "s%<region>%$location%g" $outputFile
sed -i -e "s%<imageName>%$imageName%g" $outputFile
sed -i -e "s%<identityName>%$identityName%g" $outputFile

az resource create \
    --resource-group $imageResourceGroup \
    --properties @$outputFile \
    --is-full-object \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n $imageName

echo "Building Image"

az resource invoke-action \
     --resource-group $imageResourceGroup \
     --resource-type  Microsoft.VirtualMachineImages/imageTemplates \
     -n $imageName \
     --action Run