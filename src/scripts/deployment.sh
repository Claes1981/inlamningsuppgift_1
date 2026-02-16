#!/bin/bash
# Todo: adjust to this project
set -e

resource_group="Inlamning1Group"
vm_name="Inlamning1VM"
location="northeurope"
ZONE="3"
VM_SIZE="Standard_F1als_v7"
CUSTOM_DATA_FILE=""

az group create --name $resource_group --location $location

az vm create \
    --resource-group $resource_group \
    --name $vm_name \
    --image Ubuntu2404 \
    --size "$VM_SIZE" \
    --zone "$ZONE" \
    --admin-username azureuser \
    --generate-ssh-keys

az vm open-port --resource-group $resource_group --name $vm_name --port 5000

vm_ip=$(az vm show -g $resource_group -n $vm_name --show-details --query publicIps -o tsv)

dotnet new mvc -n HelloDotnet
cd HelloDotnet
dotnet publish -c Release -o ./publish

ssh azureuser@$vm_ip 'wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && sudo apt update && sudo apt install -y aspnetcore-runtime-10.0'

ssh azureuser@$vm_ip 'sudo useradd --system --shell /usr/sbin/nologin --no-create-home dotnet-app; sudo mkdir -p /opt/dotnet-app; sudo chown azureuser:dotnet-app /opt/dotnet-app; sudo chmod 750 /opt/dotnet-app'

scp -r ./publish/* azureuser@$vm_ip:/opt/dotnet-app/

ssh azureuser@$vm_ip 'sudo chown -R dotnet-app:dotnet-app /opt/dotnet-app'

ssh azureuser@$vm_ip 'sudo tee /etc/systemd/system/dotnet-app.service > /dev/null << EOF
[Unit]
Description=.NET MVC Application
After=network.target

[Service]
Type=simple
User=dotnet-app
Group=dotnet-app
WorkingDirectory=/opt/dotnet-app
ExecStart=/usr/bin/dotnet /opt/dotnet-app/HelloDotnet.dll
Restart=always
RestartSec=5
Environment=ASPNETCORE_URLS=http://0.0.0.0:5000
Environment=ASPNETCORE_ENVIRONMENT=Production

[Install]
WantedBy=multi-user.target
EOF'

ssh azureuser@$vm_ip 'sudo systemctl daemon-reload && sudo systemctl enable dotnet-app.service && sudo systemctl start dotnet-app.service'

echo "Deployment complete! Visit http://$vm_ip:5000/"
