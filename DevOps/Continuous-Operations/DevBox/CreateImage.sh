#!/bin/bash
echo "Creating Image"
echo "---------------"
echo "imageResourceGroup: $1"
imageResourceGroup=$1
echo "ImageName: $2"
imageName=$2
echo "---------------"

az resource create \
    --resource-group $imageResourceGroup \
    --properties @helloImageTemplateWin.json \
    --is-full-object \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n $imageName

echo "Building Image"

az resource invoke-action \
     --resource-group $imageResourceGroup \
     --resource-type  Microsoft.VirtualMachineImages/imageTemplates \
     -n $imageName \
     --action Run