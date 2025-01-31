/// A strategy for validating error response bodies with status code 404.
///
/// The `ValidateStatus404ErrorBodyStrategy` struct provides a strategy for validating error response bodies
/// with a status code of 404 (Not Found). It conforms to the `ResponseErrorBodyDecodingStrategy` protocol
/// and defines the `isError(statusCode:)` method to check if the status code is 404.
///
/// Example usage:
/// ```
/// @ResponseErrorBodyWrapper<Body, ValidateStatus404ErrorBodyStrategy> var body: Body
/// ```
public struct ValidateStatus404ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is equal to the HTTP status code for "Not Found" (404).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 404, otherwise `false`.
    ///
    /// Example usage:
    /// ```
    /// @ResponseErrorBodyWrapper<Body, ValidateStatus404ErrorBodyStrategy> var body: Body
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.notFound.rawValue
    }
}
