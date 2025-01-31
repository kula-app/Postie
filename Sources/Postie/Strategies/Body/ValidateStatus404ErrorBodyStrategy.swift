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
    /// let isError = ValidateStatus404ErrorBodyStrategy.isError(statusCode: 404)
    /// print(isError) // true
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.notFound.rawValue
    }
}
