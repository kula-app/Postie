/// A strategy for validating error response bodies with status code 403.
///
/// The `ValidateStatus403ErrorBodyStrategy` struct provides a strategy for validating error response bodies
/// with a status code of 403 (Forbidden). It conforms to the `ResponseErrorBodyDecodingStrategy` protocol
/// and defines the `isError(statusCode:)` method to check if the status code is 403.
///
/// Example usage:
/// ```
/// @ResponseErrorBodyWrapper<Body, ValidateStatus403ErrorBodyStrategy> var body: Body
/// ```
public struct ValidateStatus403ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is equal to the HTTP status code for "Forbidden" (403).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 403 (Forbidden), `false` otherwise.
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.forbidden.rawValue
    }
}
