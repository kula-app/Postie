/// A strategy for validating the body of a response with a status code of 410.
///
/// The `ValidateStatus410ErrorBodyStrategy` struct provides a strategy for validating the body of a response with a status code of 410.
///
/// Example usage:
/// ```
/// @ResponseErrorBodyWrapper<Body, ValidateStatus410ErrorBodyStrategy> var body: Body
/// ```
public struct ValidateStatus410ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is equal to the HTTP status code for "Gone" (410).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 410, otherwise `false`.
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.gone.rawValue
    }
}
