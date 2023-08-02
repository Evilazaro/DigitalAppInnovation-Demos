#!/bin/bash


ESLZPrefix="Contoso"
Location="EASTUS2"
DeploymentName="Contoso-EntScale"
TenantRootGroupId="2a44cbaf-da25-4a57-bf6c-7fcfb4267163"
ManagementSubscriptionId="9e946e16-45cd-4e6a-ad69-bb7c5e24c230"
ConnectivitySubscriptionId="9e946e16-45cd-4e6a-ad69-bb7c5e24c230"
ConnectivityAddressPrefix="9e946e16-45cd-4e6a-ad69-bb7c5e24c230"
IdentitySubscriptionId="9e946e16-45cd-4e6a-ad69-bb7c5e24c230"
SecurityContactEmailAddress="evilazaro@gmail.com"
CorpConnectedLandingZoneSubscriptionId="9e946e16-45cd-4e6a-ad69-bb7c5e24c230" 
OnlineLandingZoneSubscriptionId="9e946e16-45cd-4e6a-ad69-bb7c5e24c230"
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
NAME="Contoso-alz-"${dateYMD}
ConnectivityAddressPrefix="10.100.0.0/16"
RgName="Contoso-Web-Solution-Prod"
DevBoxSubnetName="devbox-subnet"
DevBoxSubnetAddress="10.100.0.0/24"
GatewaySubnetName="gateway-subnet"
GatewaySubnetAddress="10.100.1.0/24"
VnetRg=${ESLZPrefix}"-vnethub-"${Location}
VnetName=${ESLZPrefix}"-hub-"${Location}

az login

az account set --subscription "9e946e16-45cd-4e6a-ad69-bb7c5e24c230"


clear


echo "|************************************************************************************************************************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|*********************************************** Deploying management group structure for Enterprise-Scale **************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|************************************************************************************************************************************************************************************|"

# Deploying management group structure for Enterprise-Scale
az deployment tenant create --name $NAME \
                            --location $Location \
                            --template-file ./eslzArm/managementGroupTemplates/mgmtGroupStructure/mgmtGroupsLite.json \
                            --parameters topLevelManagementGroupPrefix=$ESLZPrefix                


echo "|************************************************************************************************************************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|***********************************************  Deploy Log Analytics Workspace to the platform management subscription ************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|************************************************************************************************************************************************************************************|"

# Deploy Log Analytics Workspace to the platform management subscription
az deployment sub create --name ${NAME}"-la" \
                         --location $Location \
                         --template-file ./eslzArm/subscriptionTemplates/logAnalyticsWorkspace.json  \
                         --parameters rgName=${ESLZPrefix}"-mgmt" \
                                      workspaceName=${ESLZPrefix}"-law" \
                                      workspaceRegion=$Location \
                                      retentionInDays=30 \
                                      automationAccountName=${ESLZPrefix}"-aauto" \
                                      automationRegion=$Location \
                         

echo "|************************************************************************************************************************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|*********************************************** Deploy Log Analytics Solutions to the Log Analytics workspace in the platform management subscription ******************************|"
echo "|                                                                                                                                                                                    |"
echo "|************************************************************************************************************************************************************************************|"

# Deploy Log Analytics Solutions to the Log Analytics workspace in the platform management subscription
az deployment sub create --name ${NAME}"-la-solution" \
                         --location $Location \
                         --template-file ./eslzArm/subscriptionTemplates/logAnalyticsSolutions.json  \
                         --parameters rgName=${ESLZPrefix}"-mgmt" \
                                      workspaceName=${ESLZPrefix}"-law" \
                                      workspaceRegion=$Location \
                         


echo "|************************************************************************************************************************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|***********************************************  Create connectivity hub, using traditional hub & spoke in this example ************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|************************************************************************************************************************************************************************************|"

# Create connectivity hub, using traditional hub & spoke in this example
az deployment sub create --name ${NAME}"-hubspoke" \
                         --location $Location \
                         --template-file ./eslzArm/subscriptionTemplates/hubspoke-connectivity.json  \
                         --parameters topLevelManagementGroupPrefix=$ESLZPrefix \
                                      connectivitySubscriptionId=$ConnectivitySubscriptionId \
                                      addressPrefix=$ConnectivityAddressPrefix \
                                      enableHub="vhub" \
                                      enableAzFw="No" \
                                      enableAzFwDnsProxy="No" \
                                      enableVpnGw="No" \
                                      enableErGw="No" \
                                      enableDdoS="No"


az network vnet subnet create --name $DevBoxSubnetName \
                              --vnet-name $VnetName \
                              --resource-group $VnetRg \
                              --address-prefixes $DevBoxSubnetAddress


az network vnet subnet update \
    --name $DevBoxSubnetName \
    --vnet-name $VnetName \
    --resource-group $VnetRg \
    --disable-private-link-service-network-policies yes
                         

echo "|************************************************************************************************************************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|***********************************************  # Add the first online connected landing zone subscription to Online management group *********************************************|"
echo "|                                                                                                                                                                                    |"
echo "|************************************************************************************************************************************************************************************|"

# Add the first online connected landing zone subscription to Online management group
az deployment mg create --name ${NAME}"-online" \
                        --management-group-id ${ESLZPrefix}"-online" \
                        --location $Location \
                        --template-file ./eslzArm/managementGroupTemplates/subscriptionOrganization/subscriptionOrganization.json \
                        --parameters targetManagementGroupId=${ESLZPrefix}"-online" subscriptionId=$OnlineLandingZoneSubscriptionId 


echo "|************************************************************************************************************************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|***********************************************  # The $ESLZPrefix has been deployed successfuly ***********************************************************************************|"
echo "|                                                                                                                                                                                    |"
echo "|************************************************************************************************************************************************************************************|"