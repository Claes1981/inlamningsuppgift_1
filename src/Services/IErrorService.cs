using Microsoft.AspNetCore.Http;
using inlamningsuppgift_1.Models;

namespace inlamningsuppgift_1.Services;

/// <summary>
/// Interface for error handling operations.
/// Follows Interface Segregation Principle by defining only error-related methods.
/// </summary>
public interface IErrorService
{
    /// <summary>
    /// Extracts error details from the HTTP context.
    /// </summary>
    /// <param name="context">The current HTTP context containing error information</param>
    /// <returns>An ErrorViewModel populated with relevant diagnostic data</returns>
    ErrorViewModel GetErrorDetails(HttpContext context);
}
