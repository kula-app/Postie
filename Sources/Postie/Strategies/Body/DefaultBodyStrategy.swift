public struct DefaultBodyStrategy: ResponseBodyDecodingStrategy {
    /// Determines whether the decoding should fail when no content is returned.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
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
