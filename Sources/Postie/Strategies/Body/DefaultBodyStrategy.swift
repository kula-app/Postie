/// A default strategy for validating response bodies.
///
/// The `DefaultBodyStrategy` struct provides a default strategy for validating response bodies
/// by checking if the status code is between 200 (OK) and 300 (Multiple Choices).
/// It conforms to the `ResponseBodyDecodingStrategy` protocol and defines the
/// `allowsEmptyContent(for:)` and `validate(statusCode:)` methods.
///
/// Example usage:
/// ```
/// @ResponseBodyWrapper<Body, DefaultBodyStrategy> var body: Body
/// ```
public struct DefaultBodyStrategy: ResponseBodyDecodingStrategy {
    /// Determines whether the decoding should fail when no content is returned.
    ///
    /// - Returns: A Boolean value indicating whether empty content is allowed.
    ///
    /// Example usage:
    /// ```
    /// let allowsEmpty = DefaultBodyStrategy.allowsEmptyContent(for: 204)
    /// print(allowsEmpty) // Output: false
    /// ```
    public static func allowsEmptyContent(for _: Int) -> Bool {
        false
    }

    /// Validates the HTTP status code to determine if it is within the acceptable range.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether the status code is valid.
    ///
    /// Example usage:
    /// ```
    /// let isValid = DefaultBodyStrategy.validate(statusCode: 200)
    /// print(isValid) // Output: true
    /// ```
    public static func validate(statusCode: Int) -> Bool {
        HTTPStatusCode.ok..<HTTPStatusCode.multipleChoices ~= statusCode
    }
}
