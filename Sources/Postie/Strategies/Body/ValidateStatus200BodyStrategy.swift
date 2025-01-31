public struct ValidateStatus200BodyStrategy: ResponseBodyDecodingStrategy {
    /// Indicates whether empty content is allowed for the given status code.
    ///
    /// This method always returns `false` for status code 200, indicating that empty content is not allowed.
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether empty content is allowed.
    public static func allowsEmptyContent(for _: Int) -> Bool {
        false
    }

    /// Validates the HTTP status code to determine if it is 200 (OK).
    ///
    /// This method checks if the given status code is equal to 200 (OK).
    ///
    /// - Parameter statusCode: The HTTP status code of the response.
    /// - Returns: A Boolean value indicating whether the status code is 200 (OK).
    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.ok.rawValue
    }
}
