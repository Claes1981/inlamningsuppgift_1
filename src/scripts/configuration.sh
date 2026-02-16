#!/bin/bash
set -euo pipefail

# Constants
RESOURCE_GROUP="Inlamning1Group"
VM_NAME="Inlamning1VM"
LOCATION="northeurope"
ZONE="3"
VM_SIZE="Standard_F1als_v7"
APP_NAME="HelloDotnet"
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

function setup_dotnet_runtime() {
    local ip=$1
    echo "Setting up .NET runtime on VM..."
    if ! ssh "$USERNAME@$ip" "wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
        sudo dpkg -i packages-microsoft-prod.deb && \
        rm packages-microsoft-prod.deb && \
        sudo apt update && \
        sudo apt install -y $DOTNET_RUNTIME_VERSION"; then
        log_error ".NET runtime installation failed"
    fi
}

function create_app_user() {
    local ip=$1
    echo "Creating application user and directory..."
    if ! ssh "$USERNAME@$ip" "sudo useradd --system --shell /usr/sbin/nologin --no-create-home dotnet-app; \
        sudo mkdir -p $INSTALL_DIR; \
        sudo chown azureuser:dotnet-app $INSTALL_DIR; \
        sudo chmod 750 $INSTALL_DIR"; then
        log_error "Failed to create app user or directory"
    fi
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

function create_systemd_service() {
    local ip=$1
    echo "Creating systemd service..."
    local service_config="[Unit]\nDescription=.NET MVC Application\nAfter=network.target\n\n[Service]\nType=simple\nUser=dotnet-app\nGroup=dotnet-app\nWorkingDirectory=$INSTALL_DIR\nExecStart=/usr/bin/dotnet $INSTALL_DIR/$APP_NAME.dll\nRestart=always\nRestartSec=5\nEnvironment=ASPNETCORE_URLS=http://0.0.0.0:$PORT\nEnvironment=ASPNETCORE_ENVIRONMENT=Production\n\n[Install]\nWantedBy=multi-user.target"
    
    if ! ssh "$USERNAME@$ip" "sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null << 'EOF'\n$service_config\nEOF"; then
        log_error "Failed to create systemd service"
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

function build_and_publish_app() {
    echo "Building and publishing .NET application..."
    dotnet new mvc -n "$APP_NAME"
    cd "$APP_NAME" || exit 1
    dotnet publish -c Release -o ./publish
}

function main() {
    # Build the application first
    build_and_publish_app
       
    # Deploy application
    vm_ip=$(get_vm_ip)
    setup_dotnet_runtime "$vm_ip"
    create_app_user "$vm_ip"
    deploy_application "$vm_ip"
    set_permissions "$vm_ip"
    create_systemd_service "$vm_ip"
    start_service "$vm_ip"
    
    echo "Deployment complete! Visit http://$vm_ip:$PORT/"
}

main
