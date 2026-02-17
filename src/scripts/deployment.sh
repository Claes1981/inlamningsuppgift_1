#!/bin/bash
set -euo pipefail

# Constants
RESOURCE_GROUP="Inlamning1Group"
VM_NAME="Inlamning1VM"
LOCATION="northeurope"
ZONE="3"
VM_SIZE="Standard_F1als_v7"
APP_NAME="inlamningsuppgift_1"
LOCAL_APP_DIR="/file-systems/data/Git-repos/Cloud-developer/GrundMoln/inlamningsuppgift_1/src"
PORT="5000"
DOTNET_RUNTIME_VERSION="aspnetcore-runtime-10.0"
INSTALL_DIR="/opt/dotnet-app"
SERVICE_NAME="dotnet-app"
USERNAME="azureuser"

function log_error() {
    echo "ERROR: $1" >&2
    exit 1
}

function get_vm_ip() {
    az vm show --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --show-details --query publicIps -o tsv
}

function deploy_application() {
    local ip=$1
    echo "Deploying application files..."
    if ! scp -r ./publish/* "$USERNAME@$ip:$INSTALL_DIR/"; then
        log_error "Application deployment failed"
    fi
}

function set_permissions() {
    local ip=$1
    echo "Setting file permissions..."
    if ! ssh "$USERNAME@$ip" "sudo chown -R dotnet-app:dotnet-app $INSTALL_DIR"; then
        log_error "Failed to set permissions"
    fi
}

function start_service() {
    local ip=$1
    echo "Starting application service..."
    if ! ssh "$USERNAME@$ip" "sudo systemctl daemon-reload && \
        sudo systemctl enable $SERVICE_NAME.service && \
        sudo systemctl start $SERVICE_NAME.service"; then
        log_error "Failed to start service"
    fi
}

function publish_app() {
    echo "Publishing .NET application..."
    cd "$LOCAL_APP_DIR" || exit 1
    dotnet publish -c Release -o ./publish
}

function main() {
    vm_ip=$(get_vm_ip)
    
    publish_app

    deploy_application "$vm_ip"
    set_permissions "$vm_ip"
    start_service "$vm_ip"

    echo "Deployment complete! Visit http://$vm_ip:$PORT/"
}

main