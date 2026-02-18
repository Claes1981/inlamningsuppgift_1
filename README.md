# Inlamningsuppgift 1

This is an ASP.NET Core web application built with .NET 10.0, designed as part of a cloud development assignment. The application demonstrates deployment to Azure VMs and includes automation scripts for provisioning, configuration, and deployment.

## Architecture Overview

```
┌───────────────────────────────────────────────────────┐
│                 Client (Browser)                      │
└───────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌───────────────────────────────────────────────────────┐
│               ASP.NET Core App                        │
│                                                       │
│  ┌─────────────┐     ┌─────────────┐     ┌──────────┐ │
│  │   Route     │     │  Controller │     │   View   │ │
│  │  Handling   │───▶│  (Home)     │───▶│  (Razor) │ │
│  └─────────────┘     └─────────────┘     └──────────┘ │
│                                                       │
│  Program.cs sets up MVC pipeline and routing          │
└───────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌───────────────────────────────────────────────────────┐
│                Response HTML                          │
│  (Rendered from Index.cshtml)                         │
└───────────────────────────────────────────────────────┘
```

## Application Structure

The project follows standard MVC (Model-View-Controller) patterns using Razor views for the frontend.

### Project Layout

```
inlamningsuppgift_1/
└── src/
    ├── Controllers/           # MVC controllers
    ├── Models/                # Data models and view models
    ├── Services/              # Business logic services
    ├── Views/                 # Razor views organized by controller
    │   └── Home/              # Views for HomeController
    │       ├── Index.cshtml   # Main page template
    │       └── Privacy.cshtml # Privacy policy page
    ├── wwwroot/               # Static files (CSS, JS, images)
    ├── appsettings.json       # Configuration settings
    ├── Program.cs             # Application entry point and configuration
    └── inlamningsuppgift_1.csproj # Project file
```

## Deployment Architecture

This application includes automated deployment scripts for Azure VM provisioning:

```
┌─────────────────────────────────────────────────────────┐
│                   Local Development                     │
│  ┌─────────────┐       ┌─────────────────────────────┐  │
│  │ .NET App    │       │ Deployment Scripts          │  │
│  │ (src/)      │◀───▶│ - provision_vm.sh           │  │
│  └─────────────┘       │ - configuration.sh          │  │
│                        │ - deployment.sh             │  │
│                        │ - delete_resource_group.sh  │  │
│                        └─────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│                     Azure Cloud                         │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │ Resource Group: Inlamning1Group                 │    │
│  │                                                 │    │
│  │  ┌───────────────────────────────────────────┐  │    │
│  │  │ Virtual Machine: Inlamning1VM             │  │    │
│  │  │ - Ubuntu 24.04                            │  │    │
│  │  │ - .NET Runtime 10.0                       │  │    │
│  │  │ - Systemd Service                         │  │    │
│  │  │ - Port 5000 open                          │  │    │
│  │  └───────────────────────────────────────────┘  │    │
│  │                                                 │    │
│  │  ┌───────────────────────────────────────────┐  │    │
│  │  │ Application Files (/opt/dotnet-app)       │  │    │
│  │  │ - inlamningsuppgift_1.dll                 │  │    │
│  │  │ - Static files                            │  │    │
│  │  │ - Configuration                           │  │    │
│  │  └───────────────────────────────────────────┘  │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│                   Client Browser                        │
└─────────────────────────────────────────────────────────┘
```

## How It Works

### Local Development

1. **User Request**: A user visits the site via browser
2. **Routing**: The request is routed through the pipeline configured in `Program.cs`
3. **Controller Action**: Routes map to controller methods (e.g., `HomeController.Index()`)
4. **View Rendering**: Controllers return view results that render Razor templates
5. **Response**: Rendered HTML is sent back to the client

### Azure Deployment Workflow

The deployment process follows these steps:

1. **Provision VM** (`provision_vm.sh`):
   - Creates Azure Resource Group and Virtual Machine
   - Configures Ubuntu 24.04 server
   - Opens port 5000 for HTTP traffic

2. **Configure Environment** (`configuration.sh`):
   - Installs .NET Runtime 10.0 on the VM
   - Creates dedicated system user for application
   - Sets up Systemd service for automatic startup

3. **Deploy Application** (`deployment.sh`):
   - Publishes .NET application in Release mode
   - Copies published files to VM
   - Starts the application as a background service

4. **Access Application**: After deployment, access at `http://<VM_IP>:5000`

## Key Features

- **ASP.NET Core MVC**: Model-View-Controller architecture
- **.NET 10.0**: Latest LTS version of .NET
- **Razor Views**: Server-side rendering with Razor syntax
- **Dependency Injection**: Built-in DI container for services
- **Azure Automation**: Scripts for end-to-end cloud deployment
- **Systemd Integration**: Production-grade service management
- **Portable Deployment**: Ready for cloud or on-premise hosting

## Development Commands

### Local Development

Run locally during development:

```bash
dotnet run --project src/inlamningsuppgift_1.csproj
```

Starts the development server at:
- https://localhost:5001 (HTTPS)
- http://localhost:5000 (HTTP)

For automatic restart on code changes:

```bash
dotnet watch run --project src/inlamningsuppgift_1.csproj
```

### Build and Clean

Clean previous builds and restore dependencies:

```bash
dotnet clean && dotnet restore && dotnet build --project src/inlamningsuppgift_1.csproj
```

Build only:

```bash
dotnet build --project src/inlamningsuppgift_1.csproj
```

### Azure Deployment

#### Prerequisites

- Azure CLI installed and configured
- Active Azure subscription
- SSH keys set up for authentication

#### Step-by-Step Deployment

1. **Provision Virtual Machine**

   ```bash
   ./src/scripts/provision_vm.sh
   ```

2. **Configure Environment**

   ```bash
   ./src/scripts/configuration.sh
   ```

3. **Deploy Application**

   ```bash
   ./src/scripts/deployment.sh
   ```

4. **Access Your Application**

   After running `deployment.sh`, it will display the VM's public IP address.

5. **Clean Up Resources**

   To delete all deployed resources when no longer needed:

   ```bash
   ./src/scripts/delete_resource_group.sh
   ```

This removes the Resource Group, VM, and all associated resources.

## Script Reference

The deployment scripts in `/src/scripts/` automate the entire cloud deployment process:

### provision_vm.sh

Creates Azure infrastructure:
- Creates Resource Group "Inlamning1Group"
- Provisions Ubuntu 24.04 VM with zone 3
- Opens port 5000 for HTTP traffic
- Outputs VM public IP after creation

### configuration.sh

Configures the VM environment:
- Installs .NET Runtime 10.0
- Creates dedicated system user "dotnet-app"
- Sets up Systemd service for application management
- Configures service to auto-restart on failure

### deployment.sh

Deploys the application:
- Publishes .NET app in Release mode
- Copies files to VM at `/opt/dotnet-app`
- Sets proper ownership permissions
- Starts and enables the Systemd service
- Displays access URL upon completion

### delete_resource_group.sh

Cleans up resources:
- Deletes the entire Resource Group
- Removes VM, storage, and networking resources
- Runs asynchronously (--no-wait flag)

## Code Style Guidelines

Follow these conventions throughout the project:

- **Naming**: PascalCase for classes/methods, camelCase for variables
- **Null Safety**: Use nullable reference types (`string?` vs `string`)
- **Async/Await**: Always use async patterns for I/O operations
- **Error Handling**: Prefer specific exceptions over generic ones
- **Formatting**: Run `dotnet format` before committing