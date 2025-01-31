public struct ValidateStatus410ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is equal to the HTTP status code for "Gone" (410).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 410, otherwise `false`.
    ///
    /// Example usage:
    /// ```
    /// @ResponseErrorBodyWrapper<Body, ValidateStatus410ErrorBodyStrategy> var body: Body
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.gone.rawValue
    }
}
