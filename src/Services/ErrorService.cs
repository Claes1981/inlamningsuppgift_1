using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using inlamningsuppgift_1.Models;

namespace inlamningsuppgift_1.Services;

/// <summary>
/// Concrete implementation of IErrorService that handles error extraction logic.
/// Follows Single Responsibility Principle by focusing solely on error processing.
/// </summary>
public class ErrorService : IErrorService
{
/// <summary>
/// Extracts error details from the HTTP context and populates the view model.
/// Follows Single Responsibility Principle by focusing solely on error processing logic.
/// </summary>
/// <param name="context">The current HTTP context containing error information</param>
/// <returns>An ErrorViewModel populated with relevant diagnostic data including request ID and basic error information</returns>
public ErrorViewModel GetErrorDetails(HttpContext context)
{
    var model = new ErrorViewModel();

    // Extract request ID if available for debugging purposes
    model.RequestId = context.TraceIdentifier;
    
    // Get status code from response if available
    if (context.Response.StatusCode > 0)
    {
        model.StatusCode = context.Response.StatusCode;
    }
    
    // Provide appropriate error messages based on environment
    var webHostEnvironment = context.RequestServices.GetRequiredService<IWebHostEnvironment>();
    
    if (webHostEnvironment.IsDevelopment())
    {
        var exceptionHandlerFeature = context.Features.Get<IExceptionHandlerFeature>();
        if (exceptionHandlerFeature?.Error != null)
        {
            model.ErrorMessage = exceptionHandlerFeature.Error.Message;
            model.TechnicalDetails = exceptionHandlerFeature.Error.ToString();
        }
        else
        {
            model.ErrorMessage = "A development error occurred.";
        }
    }
    else
    {
        // In production, provide a generic user-friendly message
        model.ErrorMessage = "An unexpected error occurred. Please try again later.";
    }

    return model;
}
}
