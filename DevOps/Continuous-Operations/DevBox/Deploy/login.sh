#!/bin/bash

# This script is designed to help a user log in to their Azure account and set a specific subscription as active.

# Clear the terminal screen for better readability.
clear

# Print a header to indicate the start of the Azure login process.
echo "Logging in to Azure"
echo "-------------------"

# Display the subscription ID the user intends to set as active.
echo "Subscription: $1"
echo "-------------------"

# Use the Azure CLI to prompt the user to log in to their Azure account.
# The user will be redirected to a browser-based authentication process.
az login

# After successful login, set the specified subscription (provided as the first argument) as the active subscription.
az account set --subscription $1
