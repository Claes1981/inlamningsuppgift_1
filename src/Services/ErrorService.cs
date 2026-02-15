using Microsoft.AspNetCore.Http;
using inlamningsuppgift_1.Models;

namespace inlamningsuppgift_1.Services;

/// <summary>
/// Concrete implementation of IErrorService that handles error extraction logic.
/// Follows Single Responsibility Principle by focusing solely on error processing.
/// </summary>
public class ErrorService : IErrorService
{
    /// <summary>
    /// Extracts error details from the HTTP context.
    /// </summary>
    /// <param name="context">The current HTTP context containing error information</param>
    /// <returns>An ErrorViewModel populated with relevant diagnostic data</returns>
    public ErrorViewModel GetErrorDetails(HttpContext context)
    {
        var model = new ErrorViewModel();

        // Extract request ID if available for debugging purposes
        model.RequestId = context.TraceIdentifier;

        return model;
    }
}
