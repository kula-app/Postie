/// A strategy for validating error response bodies with status code 401.
///
/// The `ValidateStatus401ErrorBodyStrategy` struct provides a strategy for validating error response bodies
/// with a status code of 401 (Unauthorized). It conforms to the `ResponseErrorBodyDecodingStrategy` protocol
/// and defines the `isError(statusCode:)` method to check if the status code is 401.
///
/// Example usage:
/// ```
/// @ResponseErrorBodyWrapper<Body, ValidateStatus401ErrorBodyStrategy> var body: Body
/// ```
public struct ValidateStatus401ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Checks if the given status code represents an error.
    ///
    /// This method checks if the given status code is equal to 401 (Unauthorized).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 401, `false` otherwise.
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.unauthorized.rawValue
    }
}
