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
$imageResourceGroup="Contoso-VM-Images"  
# Location  
$location="eastus2"  
# Image distribution metadata reference name  
$runOutputName="aibCustWinManImg01"  
# Image template name  
$imageTemplateName="vscodeWinTemplate"

# Set up role def names, which need to be unique 
$timeInt=$(get-date -UFormat "%s") 
$imageRoleDefName="Azure Image Builder Image Def"+$timeInt 
$identityName="aibIdentity"+$timeInt 

## Add an Azure PowerShell module to support AzUserAssignedIdentity 
Install-Module -Name Az.ManagedServiceIdentity 

# Create an identity 
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location

$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id 
$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId

$aibRoleImageCreationUrl="https://raw.githubusercontent.com/azure/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json" 
$aibRoleImageCreationPath = "aibRoleImageCreation.json" 

# Download the configuration 
Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $aibRoleImageCreationPath 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $aibRoleImageCreationPath 
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath 

# Create a role definition 
New-AzRoleDefinition -InputFile  ./aibRoleImageCreation.json 
# Grant the role definition to the VM Image Builder service principal 
New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"