public struct ValidateStatus422ErrorBodyStrategy: ResponseErrorBodyDecodingStrategy {
    /// Determines if the given status code represents an error.
    ///
    /// This method checks if the provided status code is equal to the HTTP status code for "Unprocessable Entity" (422).
    ///
    /// - Parameter statusCode: The status code to check.
    /// - Returns: `true` if the status code is 422, otherwise `false`.
    ///
    /// Example usage:
    /// ```
    /// @ResponseErrorBodyWrapper<Body, ValidateStatus422ErrorBodyStrategy> var body: Body
    /// ```
    public static func isError(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.unprocessableEntity.rawValue
    }
}

