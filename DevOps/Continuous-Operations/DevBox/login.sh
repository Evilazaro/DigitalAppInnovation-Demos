#!/bin/bash
clear

echo "Logging in to Azure"
echo "-------------------"
echo "Subscription: $1"
echo "-------------------"

az login

az account set --subscription $1