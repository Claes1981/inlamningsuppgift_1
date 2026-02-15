# Inlamningsuppgift 1

This is an ASP.NET Core web application built with .NET 10.0.

## Application Structure

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

1. **User Request**: When a user visits the site, their browser sends a request to the server
2. **Routing**: The request is handled by the routing system defined in `Program.cs`
3. **Controller Action**: The route maps to `HomeController.Index()` method
4. **View Rendering**: The controller returns a view result, which renders the Razor template (`Index.cshtml`)
5. **Response**: The rendered HTML is sent back to the client's browser

## Key Files

- `src/Program.cs`: Sets up the ASP.NET Core application and configures middleware
- `src/Controllers/HomeController.cs`: Contains the controller actions for handling requests
- `src/Views/Home/Index.cshtml`: The Razor view that generates the HTML response
