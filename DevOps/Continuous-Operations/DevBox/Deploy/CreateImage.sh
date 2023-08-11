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
echo "runOutputName: $6"
runOutputName=$6
echo "imgBuilderId: $7"
imgBuilderId=$7
echo "imageTemplateFile: $8"
imageTemplateFile=$8
echo "---------------"

curl $imageTemplateFile -o $outputFile
echo "---------------"
echo "imageTemplateFile: $imageTemplateFile"

sed -i -e "s%<subscriptionID>%$subscriptionID%g" $outputFile
sed -i -e "s%<rgName>%$imageResourceGroup%g" $outputFile
sed -i -e "s%<region>%$location%g" $outputFile
sed -i -e "s%<imageName>%$imageName%g" $outputFile
sed -i -e "s%<runOutputName>%$runOutputName%g" $outputFile
sed -i -e "s%<imgBuilderId>%$imgBuilderId%g" $outputFile

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