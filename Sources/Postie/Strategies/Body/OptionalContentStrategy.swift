/// A strategy for validating response bodies with status code 204.
///
/// The `OptionalContentStrategy` struct provides a strategy for validating response bodies
/// with a status code of 204 (No Content). It conforms to the `ResponseBodyDecodingStrategy` protocol
/// and defines the `allowsEmptyContent(for:)` and `validate(statusCode:)` methods.
///
/// Example usage:
/// ```
/// @ResponseBodyWrapper<Body, OptionalContentStrategy> var body: Body
/// ```
public struct OptionalContentStrategy: ResponseBodyDecodingStrategy {
    /// Determines whether the decoding should fail when no content is returned.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether empty content is allowed.
    ///
    /// Example usage:
    /// ```
    /// let allowsEmpty = OptionalContentStrategy.allowsEmptyContent(for: 204)
    /// print(allowsEmpty) // Output: true
    /// ```
    public static func allowsEmptyContent(for statusCode: Int) -> Bool {
        statusCode == 204
    }

    /// Validates the HTTP status code to determine if it is within the acceptable range.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether the status code is valid.
    ///
    /// Example usage:
    /// ```
    /// let isValid = OptionalContentStrategy.validate(statusCode: 200)
    /// print(isValid) // Output: true
    /// ```
    public static func validate(statusCode: Int) -> Bool {
        DefaultBodyStrategy.validate(statusCode: statusCode)
    }
}
