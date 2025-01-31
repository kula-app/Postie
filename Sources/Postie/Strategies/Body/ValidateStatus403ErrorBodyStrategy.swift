public struct ValidateStatus403ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is equal to the HTTP status code for "Forbidden" (403).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 403 (Forbidden), `false` otherwise.
    ///
    /// Example usage:
    /// ```
    /// let isError = ValidateStatus403ErrorBodyStrategy.isError(statusCode: 403)
    /// print(isError) // true
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.forbidden.rawValue
    }
}
