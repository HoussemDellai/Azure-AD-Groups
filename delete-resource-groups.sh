#!/bin/bash

# NOTE: Be careful as this code in intended 
# to delete ALL Resources in a subscription.

# Set The correct Subscription
az account list -o table
az account set -s "Visual Studio Enterprise Subscription #6"

# Get All resource groups and loop to delete them
for rg_name in `az group list -o tsv --query [*].name`; do
    echo Deleting $rg_name ...
    az group delete -n $rg_name --yes --no-wait
done
