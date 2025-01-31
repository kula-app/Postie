public struct DefaultErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is greater than or equal to the HTTP status code for a bad request (400).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code represents an error, `false` otherwise.
    ///
    /// Example usage:
    /// ```
    /// let isError = DefaultErrorBodyStrategy.isError(statusCode: 404)
    /// print(isError) // Prints: true
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode >= HTTPStatusCode.badRequest.rawValue
    }
}
