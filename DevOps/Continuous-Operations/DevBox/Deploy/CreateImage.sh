#!/bin/bash
echo "Creating Image"
echo "---------------"
echo "imageResourceGroup: $1"
imageResourceGroup=$1
echo "ImageName: $2"
imageName=$2
echo "ImageTemplateFile: $3"
imageTemplateFile=$3
echo "---------------"

curl https://raw.githubusercontent.com/Evilazaro/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json -o $imageTemplateFile

sed -i -e "s%<subscriptionID>%$subscriptionID%g" $imageTemplateFile
sed -i -e "s%<rgName>%$imageResourceGroup%g" $imageTemplateFile
sed -i -e "s%<region>%$location%g" $imageTemplateFile
sed -i -e "s%<imageName>%$imageName%g" $imageTemplateFile
sed -i -e "s%<runOutputName>%$runOutputName%g" $imageTemplateFile
sed -i -e "s%<imgBuilderId>%$imgBuilderId%g" $imageTemplateFile

az resource create \
    --resource-group $imageResourceGroup \
    --properties @$imageTemplateFile \
    --is-full-object \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n $imageName

echo "Building Image"

az resource invoke-action \
     --resource-group $imageResourceGroup \
     --resource-type  Microsoft.VirtualMachineImages/imageTemplates \
     -n $imageName \
     --action Run