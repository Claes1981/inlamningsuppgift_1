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
    
    # Create the service file using a simple approach without complex quoting
    if ! ssh "$USERNAME@$ip" "sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null" << EOF
[Unit]
Description=.NET MVC Application
After=network.target

[Service]
Type=simple
User=dotnet-app
Group=dotnet-app
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/dotnet \$INSTALL_DIR/\$APP_NAME.dll
Restart=always
RestartSec=5
Environment=ASPNETCORE_URLS=http://0.0.0.0:\$PORT
Environment=ASPNETCORE_ENVIRONMENT=Production

[Install]
WantedBy=multi-user.target
EOF
    then
        log_error "Failed to write systemd service configuration"
    fi
    
    if ! ssh "$USERNAME@$ip" "sudo chmod 644 /etc/systemd/system/$SERVICE_NAME.service && sudo systemctl daemon-reload"; then
        log_error "Failed to set permissions and reload systemd"
    fi
}

function main() {

    vm_ip=$(get_vm_ip)
    setup_dotnet_runtime "$vm_ip"
    create_app_user "$vm_ip"
    set_permissions "$vm_ip"
    create_systemd_service "$vm_ip"
    
    echo "Configuration complete!"
}

main
