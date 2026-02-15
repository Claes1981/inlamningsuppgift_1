# Inlamningsuppgift 1

This is an ASP.NET Core web application built with .NET 10.0.

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

### Internal Architecture Diagram

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
│                                                       │
└───────────────────────────────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────┐
│                Response HTML                          │
│  (Rendered from Index.cshtml)                         │
└───────────────────────────────────────────────────────┘
```

## How It Works

1. **User Request**: A user visits the site via browser
2. **Routing**: The request is routed through the pipeline configured in `Program.cs`
3. **Controller Action**: Routes map to controller methods (e.g., `HomeController.Index()`)
4. **View Rendering**: Controllers return view results that render Razor templates
5. **Response**: Rendered HTML is sent back to the client

## Key Features

- **ASP.NET Core MVC**: Model-View-Controller architecture
- **.NET 10.0**: Latest LTS version of .NET
- **Razor Pages**: Server-side rendering with Razor syntax
- **Dependency Injection**: Built-in DI container for services
- **Configuration**: JSON-based configuration with environment-specific overrides

## Running the Application

```bash
dotnet run --project inlamningsuppgift_1.csproj
```

Starts the development server at:
- https://localhost:5001 (HTTPS)
- http://localhost:5000 (HTTP)

For automatic restart on code changes:

```bash
dotnet watch run
```
