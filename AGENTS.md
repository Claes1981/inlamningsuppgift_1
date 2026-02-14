# AGENTS.md

This file provides guidelines for agentic coding agents working with this repository.

## Project Overview

This is an ASP.NET Core web application built with .NET 10.0. The project follows standard MVC (Model-View-Controller) patterns and uses Razor views for the frontend.

## Build, Lint, and Test Commands

### Building the Application

```bash
dotnet build
```
Builds the entire solution and compiles all projects.

```bash
dotnet clean && dotnet restore && dotnet build
```
Performs a full clean rebuild by cleaning previous builds, restoring dependencies, then building.

### Running the Application

```bash
dotnet run --project inlamningsuppgift_1.csproj
```
Runs the application in development mode using Kestrel server on `https://localhost:5001` and `http://localhost:5000`.

```bash
dotnet watch run
```
Starts the application with file watching enabled - automatically restarts when code changes are detected.

### Testing

Since this is a basic MVC application without dedicated test projects, tests would need to be added. For now:

```bash
dotnet new xunit -o Tests
```
Creates a new XUnit test project if testing infrastructure needs to be established.

To run tests once they exist:

```bash
dotnet test
```
Runs all tests in the solution.

```bash
dotnet test --filter "Category=Integration"
```
Example of running filtered tests (if categories are defined).

For running a single test class or method, you would typically use:

```bash
dotnet test --filter "FullyQualifiedName=Tests.UnitTests.Controllers.HomeControllerTests.Index_Returns_View"
```

### Code Analysis and Formatting

```bash
dotnet format
```
Applies automatic formatting to C# source code according to editorconfig settings.

```bash
dotnet format --verify-no-changes
```
Verifies that code already conforms to formatting standards without making changes.

```bash
dotnet format --check
```
Checks formatting compliance and reports issues.

```bash
dotnet format style
```
Formats both C# and JSON files.

## Code Style Guidelines

### General Principles

1. **Consistency**: Follow existing code patterns and conventions within the repository
2. **Simplicity**: Keep code simple, readable, and maintainable
3. **Type Safety**: Leverage .NET's strong typing features
4. **Null Safety**: Use nullable reference types (`Nullable enable`) throughout

### C# Coding Standards

#### Imports

- Group imports by namespace
- Place system namespaces first, followed by third-party libraries, then local project references
- Remove unused imports before committing
- Use implicit usings where appropriate (enabled via `<ImplicitUsings>enable</ImplicitUsings>`)

**Good:**
```csharp
using System;
using System.Diagnostics;
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
- **Namespaces**: Lowercase with periods separating hierarchy levels

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

**Example:**
```csharp
public IActionResult ProcessData(string inputData)
{
    if (inputData == null)
    {
        throw new ArgumentNullException(nameof(inputData));
    }

    try
    {
        var result = _dataProcessor.Process(inputData);
        return View(result);
    }
    catch (ValidationException ex)
    {
        ModelState.AddModelError("Input", ex.Message);
        return View();
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Error processing data");
        return RedirectToAction("Error");
    }
}
```

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

### Testing Conventions

When adding tests:

1. **Test Project Structure**: Organize by feature area matching the main project structure
2. **Naming**: Name test classes after the class being tested + "Tests"
3. **Methods**: Name test methods using format: `[MethodName]_[Scenario]_[ExpectedBehavior]`
4. **Arrange-Act-Assert**: Follow AAA pattern consistently
5. **Mocking**: Use Moq or NSubstitute for mocking dependencies
6. **Integration Tests**: Place in a separate folder from unit tests
7. **Test Data**: Use theory-based tests with inline data for parameterized testing

**Example Test Class:**
```csharp
namespace Tests.UnitTests.Controllers;

public class HomeControllerTests
{
    [Fact]
    public void Index_Returns_View()
    {
        // Arrange
        var controller = new HomeController();

        // Act
        var result = controller.Index();

        // Assert
        Assert.IsType<ViewResult>(result);
    }
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

## Configuration

The application uses JSON configuration files:
- `appsettings.json`: Default configuration
- `appsettings.Development.json`: Development-specific overrides

Environment variables can override these settings.

## Deployment

For production deployment:
1. Build in Release mode: `dotnet publish -c Release -o ./publish`
2. Deploy the contents of the publish directory
3. Configure web server to serve the app from the publish directory
4. Set appropriate environment variables for production

## Additional Notes

- This is an educational project, so keep it simple but maintainable
- Document non-obvious design decisions
- Consider adding XML documentation comments for public APIs
- Review security best practices for ASP.NET Core applications
