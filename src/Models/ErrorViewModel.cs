namespace inlamningsuppgift_1.Models;

/// <summary>
/// View model containing detailed error information for display.
/// Follows Single Responsibility Principle by focusing solely on error data presentation.
/// </summary>
public class ErrorViewModel
{
    /// <summary>
    /// Unique identifier for the request that encountered an error.
    /// Used for debugging and correlation purposes.
    /// </summary>
    public string? RequestId { get; set; }

    /// <summary>
    /// Human-readable error message describing what went wrong.
    /// </summary>
    public string? ErrorMessage { get; set; }

    /// <summary>
    /// Detailed technical information about the error (stack trace, etc.).
    /// Should only be shown in development environments.
    /// </summary>
    public string? TechnicalDetails { get; set; }

    /// <summary>
    /// HTTP status code associated with the error.
    /// </summary>
    public int? StatusCode { get; set; }

    /// <summary>
    /// Indicates whether the request ID should be displayed to the user.
    /// </summary>
    public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
}
