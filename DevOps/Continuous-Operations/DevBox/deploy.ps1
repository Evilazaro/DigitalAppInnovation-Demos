Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages | Format-table -Property ResourceTypes,RegistrationState 
Get-AzResourceProvider -ProviderNamespace Microsoft.Storage | Format-table -Property ResourceTypes,RegistrationState  
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute | Format-table -Property ResourceTypes,RegistrationState 
Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault | Format-table -Property ResourceTypes,RegistrationState 
Get-AzResourceProvider -ProviderNamespace Microsoft.Network | Format-table -Property ResourceTypes,RegistrationState

Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages  
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage  
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute  
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault  
Register-AzResourceProvider -ProviderNamespace Microsoft.Network

'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {Install-Module -Name $_ -AllowPrerelease}

# Get existing context 
$currentAzContext = Get-AzContext  
# Get your current subscription ID  
$subscriptionID=$currentAzContext.Subscription.Id  
# Destination image resource group  
$imageResourceGroup="Contoso-VM-Images-rg"  
# Location  
$location="eastus2"  
# Image distribution metadata reference name  
$runOutputName="aibCustWinManImg01"  
# Image template name  
$imageTemplateName="vscodeWinTemplate"

# Set up role def names, which need to be unique 
$timeInt=$(get-date -UFormat "%s") 
$imageRoleDefName="Owner"
$identityName="aibIdentity"

## Add an Azure PowerShell module to support AzUserAssignedIdentity 
Install-Module -Name Az.ManagedServiceIdentity 

# Create an identity 
#New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location

$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id 
$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId

# Grant the role definition to the VM Image Builder service principal 
#New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"
New-AzRoleAssignment -ObjectId 74238405-4949-4244-af9a-38b428397164 -RoleDefinitionName "Owner" -Scope "/subscriptions/9e946e16-45cd-4e6a-ad69-bb7c5e24c230/resourceGroups/Contoso-VM-Images-rg"

# Gallery name 
$galleryName= "ContosoDevBoxImageGallery" 

# Image definition name 
$imageDefName ="Win-BackEnd-Dev-DevBox-Image" 

# Additional replication region 
$replRegion2="eastus" 

# Create the gallery 
New-AzGallery -GalleryName $galleryName -ResourceGroupName $imageResourceGroup -Location $location 

$SecurityType = @{Name='SecurityType';Value='TrustedLaunch'} 
$features = @($SecurityType) 

# Create the image definition
New-AzGalleryImageDefinition -GalleryName $galleryName -ResourceGroupName $imageResourceGroup -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher 'Contoso' -Offer 'backend' -Sku '1-0-0' -Feature $features -HyperVGeneration "V2"

$templateFilePath = "vmtemplate.json"

(Get-Content -path $templateFilePath -Raw ) -replace '<subscriptionID>',$subscriptionID | Set-Content -Path $templateFilePath 
(Get-Content -path $templateFilePath -Raw ) -replace '<rgName>',$imageResourceGroup | Set-Content -Path $templateFilePath 
(Get-Content -path $templateFilePath -Raw ) -replace '<runOutputName>',$runOutputName | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<imageDefName>',$imageDefName | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<sharedImageGalName>',$galleryName| Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<region1>',$location | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw ) -replace '<region2>',$replRegion2 | Set-Content -Path $templateFilePath  
(Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$identityNameResourceId | Set-Content -Path $templateFilePath

New-AzResourceGroupDeployment  -ResourceGroupName $imageResourceGroup  -TemplateFile $templateFilePath  -Api-Version "2020-02-14"  -imageTemplateName $imageTemplateName  -svclocation $location

Invoke-AzResourceAction  -ResourceName $imageTemplateName  -ResourceGroupName $imageResourceGroup  -ResourceType Microsoft.VirtualMachineImages/imageTemplates  -ApiVersion "2020-02-14"  -Action Run

Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup | Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState