# AGENTS.md

This file provides guidelines for agentic coding agents working with this repository.

## Project Overview

This is an ASP.NET Core web application built with .NET 10.0. The project follows standard MVC (Model-View-Controller) patterns and uses Razor views for the frontend.

## Build, Lint, and Test Commands

### Building the Application

```bash
dotnet build --project src/inlamningsuppgift_1.csproj
```
Builds the entire solution and compiles all projects.

```bash
dotnet clean && dotnet restore && dotnet build --project src/inlamningsuppgift_1.csproj
```
Performs a full clean rebuild by cleaning previous builds, restoring dependencies, then building.

### Running the Application

```bash
dotnet run --project src/inlamningsuppgift_1.csproj
```
Runs the application in development mode using Kestrel server on `https://localhost:5001` and `http://localhost:5000`.

```bash
dotnet watch run --project src/inlamningsuppgift_1.csproj
```
Starts the application with file watching enabled - automatically restarts when code changes are detected.

### Testing

If you need to add tests:

```bash
dotnet new xunit -o Tests
```
Creates a new XUnit test project in the `Tests/` directory.

Add reference to your main project:

```bash
dotnet add Tests/Tests.csproj reference src/inlamningsuppgift_1.csproj
```

To run tests if they exist:

```bash
dotnet test
```
Runs all tests in the solution.

```bash
dotnet test --filter "FullyQualifiedName=Tests.UnitTests.Controllers.HomeControllerTests.Index_Returns_View"
```
Runs a specific test by fully qualified name.

### Code Analysis and Formatting

```bash
dotnet format
```
Applies automatic formatting to C# source code according to editorconfig settings.

```bash
dotnet format --verify-no-changes
```
Verifies that code already conforms to formatting standards without making changes.

## Code Style Guidelines

### General Principles

1. **Consistency**: Follow existing code patterns and conventions within the repository
2. **Simplicity**: Keep code simple, readable, and maintainable
3. **Type Safety**: Leverage .NET's strong typing features
4. **Null Safety**: Use nullable reference types throughout

### C# Coding Standards

#### Imports

- Group imports by namespace
- Place system namespaces first, followed by third-party libraries, then local project references
- Remove unused imports before committing
- Use implicit usings where appropriate (enabled via `<ImplicitUsings>enable</ImplicitUsings>`)

**Good:**
```csharp
using System;
using Microsoft.AspNetCore.Mvc;
using inlamningsuppgift_1.Models;
```

#### Naming Conventions

- **Classes**: PascalCase (e.g., `HomeController`, `ErrorViewModel`)
- **Methods**: PascalCase (e.g., `Index()`, `Privacy()`)
- **Variables**: camelCase (e.g., `requestId`, `errorViewModel`)
- **Private fields**: camelCase with underscore prefix (e.g., `_logger`, `_service`)
- **Constants**: UPPERCASE_WITH_UNDERSCORES (e.g., `MAX_RETRIES`, `DEFAULT_TIMEOUT`)
- **Interfaces**: I prefix followed by PascalCase (e.g., `ILogger`, `IService`)

#### Bracing and Indentation

- Open braces on same line for classes, methods, properties
- Open braces on new line for control structures (if, else, for, while, etc.)
- 4-space indentation
- Consistent brace placement throughout

**Good:**
```csharp
public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
}
```

#### Nullable Reference Types

The project has nullable reference types enabled (`<Nullable>enable</Nullable>`). Always:

- Annotate parameters that should not be null: `string name`
- Annotate parameters that can be null: `string? name`
- Annotate return values appropriately: `User? GetUser(int id)` vs `User GetCurrentUser()`
- Use null-forgiving operator (`!`) sparingly when you're certain a value is non-null

#### Error Handling

- Prefer specific exceptions over generic ones
- Use `ArgumentNullException` for null arguments
- Use `ArgumentOutOfRangeException` for invalid ranges
- Wrap external calls in try-catch blocks
- Log errors appropriately using dependency injection
- Don't swallow exceptions unless absolutely necessary

### ASP.NET Core Specific Guidelines

#### Controllers

- Keep controllers lean - move business logic to services
- Use action methods for HTTP handling only
- Validate model state before processing
- Return appropriate status codes
- Use async/await for I/O operations

**Good Pattern:**
```csharp
[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> Create(CreateModel model)
{
    if (!ModelState.IsValid)
    {
        return View(model);
    }

    try
    {
        await _service.CreateAsync(model);
        return RedirectToAction("Index");
    }
    catch (ServiceException ex)
    {
        ModelState.AddModelError(string.Empty, ex.Message);
        return View(model);
    }
}
```

#### Views

- Use strongly-typed views with `@model` directive
- Keep view logic minimal; use Razor helpers and tag helpers
- Separate concerns between layout and content views
- Use partial views for reusable components
- Follow the existing pattern of placing views in `/Views/[ControllerName]/`

**View Imports Convention:**
```razor
@using inlamningsuppgift_1
@using inlamningsuppgift_1.Models
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
```

#### Models

- Place models in the `Models/` directory
- Use data annotations for validation: `[Required]`, `[StringLength]`, etc.
- Consider using FluentValidation for complex validation scenarios
- Keep DTOs separate from domain entities when needed

**Example:**
```csharp
namespace inlamningsuppgift_1.Models;

public class ErrorViewModel
{
    public string? RequestId { get; set; }
    
    public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
}
```

## Development Workflow

1. **Branch Strategy**: Create feature branches from main/develop
2. **Commit Messages**: Use conventional commits format (feat:, fix:, docs:, style:, refactor:, test:, chore:)
3. **Code Reviews**: All changes require review before merging
4. **Documentation**: Update documentation as part of code changes
5. **Testing**: Add tests for new functionality and ensure existing tests pass

## Tools and Dependencies

- **.NET SDK 10.0+**: Required to build and run the application
- **Entity Framework Core**: For data access (if used)
- **Razor Pages**: For server-side rendering
- **ASP.NET Core MVC**: For model-view-controller pattern implementation
