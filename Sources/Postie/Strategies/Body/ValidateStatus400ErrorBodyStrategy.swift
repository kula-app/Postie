import Foundation

/// A strategy for validating and decoding error response bodies with a status code of 400.
///
/// The `ValidateStatus400ErrorBodyStrategy` struct provides a strategy for validating and decoding error response bodies
/// when the status code is 400 (Bad Request). It conforms to the `ResponseErrorBodyDecodingStrategy` protocol and
/// implements the `isError(statusCode:)` method to check if the status code is 400.
///
/// Example usage:
/// ```
/// let isError = ValidateStatus400ErrorBodyStrategy.isError(statusCode: 400)
/// print(isError) // true
/// ```
public struct ValidateStatus400ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Checks if the given status code represents an error.
    ///
    /// This method checks if the given status code is equal to 400 (Bad Request).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 400, `false` otherwise.
    ///
    /// Example usage:
    /// ```
    /// let isError = ValidateStatus400ErrorBodyStrategy.isError(statusCode: 400)
    /// print(isError) // true
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.badRequest.rawValue
    }
}
