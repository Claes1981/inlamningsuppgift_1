using Microsoft.AspNetCore.Mvc;
using inlamningsuppgift_1.Models;
using inlamningsuppgift_1.Services;
using Microsoft.Extensions.Logging;

namespace inlamningsuppgift_1.Controllers;

/// <summary>
/// Handles requests related to the home page of the application.
/// Follows Single Responsibility Principle by focusing only on HTTP request handling.
/// </summary>
public class HomeController : Controller
{
    private readonly IErrorService _errorService;
    private readonly ILogger<HomeController> _logger;

    /// <summary>
    /// Initializes a new instance of the HomeController class.
    /// </summary>
    /// <param name="errorService">Service for handling errors</param>
    /// <param name="logger">Logger for recording events</param>
    public HomeController(IErrorService errorService, ILogger<HomeController> logger)
    {
        _errorService = errorService;
        _logger = logger;
    }

    /// <summary>
    /// Displays the main index page.
    /// </summary>
    /// <returns>The view for the index page</returns>
    public IActionResult Index()
    {
        _logger.LogInformation("Rendering index page");
        return View();
    }

    /// <summary>
    /// Displays the privacy policy page.
    /// </summary>
    /// <returns>The view for the privacy policy page</returns>
    public IActionResult Privacy()
    {
        _logger.LogInformation("Rendering privacy page");
        return View();
    }

    /// <summary>
    /// Handles error responses and displays appropriate error information.
    /// </summary>
    /// <returns>The error view with relevant diagnostic information</returns>
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        var model = _errorService.GetErrorDetails(HttpContext);
        _logger.LogError("Error occurred: {RequestId}", model.RequestId);
        return View(model);
    }
}
