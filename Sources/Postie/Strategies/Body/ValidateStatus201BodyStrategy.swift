/// A strategy for validating response bodies with status code 201.
///
/// The `ValidateStatus201BodyStrategy` struct provides a strategy for validating response bodies
/// with a status code of 201 (Created). It conforms to the `ResponseBodyDecodingStrategy` protocol
/// and defines the `allowsEmptyContent(for:)` and `validate(statusCode:)` methods.
///
/// Example usage:
/// ```
/// @ResponseBodyWrapper<Body, ValidateStatus201BodyStrategy> var body: Body
/// ```
public struct ValidateStatus201BodyStrategy: ResponseBodyDecodingStrategy {
    /// Indicates whether empty content is allowed for the given status code.
    ///
    /// This method always returns `false` for status code 201, indicating that empty content is not allowed.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether empty content is allowed.
    public static func allowsEmptyContent(for statusCode: Int) -> Bool {
        false
    }

    /// Validates the HTTP status code to determine if it is 201 (Created).
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether the status code is 201 (Created).
    ///
    /// Example usage:
    /// ```
    /// let isValid = ValidateStatus201BodyStrategy.validate(statusCode: 201)
    /// print(isValid) // Output: true
    /// ```
    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.created.rawValue
    }
}
