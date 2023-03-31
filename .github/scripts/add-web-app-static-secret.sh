#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app-name> [secret-name]"
    exit 1
fi

app_name=$1
secret_name=${2:-"AZURE_STATIC_WEB_APPS_API_TOKEN"}

secretvalue=$(az staticwebapp secrets list --name "$app_name" --query properties.apiKey --output tsv)

echo "$secretvalue" | gh secret set "$secret_name" --app actions 
