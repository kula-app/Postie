public struct ValidateStatus303BodyStrategy: ResponseBodyDecodingStrategy {
    /// Indicates whether empty content is allowed for the given status code.
    ///
    /// This method always returns `true` for status code 303, indicating that empty content is allowed.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether empty content is allowed.
    public static func allowsEmptyContent(for _: Int) -> Bool {
        true
    }

    /// Validates the HTTP status code to determine if it is 303 (See Other).
    ///
    /// This method checks if the given status code is equal to the raw value of `HTTPStatusCode.seeOther`.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether the status code is 303.
    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.seeOther.rawValue
    }
}
