/// A strategy for validating error response bodies with status code 400.
///
/// The `ValidateStatus400ErrorBodyStrategy` struct provides a strategy for validating error response bodies
/// with a status code of 400 (Bad Request). It conforms to the `ResponseErrorBodyDecodingStrategy` protocol
/// and defines the `isError(statusCode:)` method to check if the status code is 400.
///
/// Example usage:
/// ```
/// @ResponseErrorBodyWrapper<Body, ValidateStatus400ErrorBodyStrategy> var body: Body
/// ```
public struct ValidateStatus400ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Checks if the given status code represents an error.
    ///
    /// This method checks if the given status code is equal to 400 (Bad Request).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 400, `false` otherwise.
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.badRequest.rawValue
    }
}
