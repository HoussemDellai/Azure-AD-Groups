# This script will do the following:
# 1. creates 3 Azure AD groups
# 2. adds members to the AD group
# 3. assign AD group to a subscription as Contributor

# Requirement: import bulk group via CSV file into Azure Portal.

# variables section

AD_GROUP_NAME="TraineesTeam1"
FROM=0
TO=10
subscription_id=$(az account list --query "[?contains(id, '7b1f7584')].[id]" -o tsv)

# AD_GROUP_NAME="TraineesTeam2"
# FROM=11
# TO=21
# subscription_id=$(az account list --query "[?contains(id, '0cb12691')].[id]" -o tsv)

# AD_GROUP_NAME="TraineesTeam3"
# FROM=22
# TO=33
# subscription_id=$(az account list --query "[?contains(id, '14fd438d')].[id]" -o tsv)

# 1. Create Azure AD Group

az ad group create --display-name $AD_GROUP_NAME --mail-nickname $AD_GROUP_NAME

# 2. Assign users to AD group

ad_users_objectId=$(az ad user list --query "[?contains(createdDateTime, '2020-05-31')].[objectId]|[$FROM:$TO]" -o tsv)

echo $ad_users_objectId

for objectId in $ad_users_objectId; do
    echo Assigning User ID $objectId to $AD_GROUP_NAME
    az ad group member add --group $AD_GROUP_NAME --member-id $objectId
done

# 3. Assign AD group to a subscription as Contributor

object_id=$(az ad group list --query "[?contains(displayName, '$AD_GROUP_NAME')].[objectId]" -o tsv)

az role assignment create --role "Contributor" --assignee-object-id $object_id --scope /subscriptions/$subscription_id
# az role assignment create --role "Contributor" --assignee-object-id $object_id --resource-group <resource_group> --scope /subscriptions/subscription_id
