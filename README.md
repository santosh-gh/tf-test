# tf-test

terraform -chdir=terraform/modules/virtual_network plan


# terraform backend
    az login

    $location="southindia"
    $resourceGroupName="tf-rg"
    $storageAccountName="tfstatestg11"
    $containerName="tfstate"    
    $sku="Standard_LRS"

    az group create --name $resourceGroupName --location $location 

    az storage account create --resource-group $resourceGroupName --name $storageAccountName --sku $sku --encryption-services blob

    $storageAccountKey=$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query [0].value -o tsv)
    echo $storageAccountKey

    az storage container create --name $containerName --account-name $storageAccountName --account-key $storageAccountKey 
