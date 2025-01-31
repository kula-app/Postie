import Foundation

/// Represents various errors that can occur when interacting with the API.
///
/// The `APIError` enum provides a comprehensive list of errors that can occur when interacting with the API.
/// Each case represents a specific type of error, and the associated values provide additional context or information
/// about the error.
///
/// - SeeAlso: `LocalizedError` for more information on localized error descriptions.
public enum APIError: LocalizedError {
    /// Indicates a response error with a specific status code and data.
    ///
    /// This error occurs when the API returns a response with a non-success status code.
    /// The associated values provide the status code and the response data.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code of the response.
    ///   - data: The response data.
    case responseError(statusCode: Int, data: Data)

    /// Indicates an invalid response.
    ///
    /// This error occurs when the API returns an invalid response, such as a response with missing or malformed data.
    case invalidResponse

    /// Indicates a URL error.
    ///
    /// This error occurs when there is an issue with the URL, such as a network connectivity problem or an invalid URL.
    ///
    /// - Parameter error: The underlying `URLError` that caused the failure.
    case urlError(URLError)

    /// Indicates a decoding error.
    ///
    /// This error occurs when there is an issue decoding the response data into the expected type.
    ///
    /// - Parameter error: The underlying `DecodingError` that caused the failure.
    case decodingError(DecodingError)

    /// Indicates a failure to encode plain text with a specific encoding.
    ///
    /// This error occurs when there is an issue encoding plain text data using the specified encoding.
    ///
    /// - Parameter encoding: The `String.Encoding` used for encoding.
    case failedToEncodePlainText(encoding: String.Encoding)

    /// Indicates an unknown error.
    ///
    /// This error occurs when an unknown error is encountered.
    ///
    /// - Parameter error: The underlying `Error` that caused the failure.
    case unknown(error: Error)

    /// A localized message describing what error occurred.
    ///
    /// This property provides a human-readable description of the error, which can be used for displaying error messages
    /// to the user.
    ///
    /// - Returns: A localized string describing the error.
    ///
    /// Example usage:
    /// ```
    /// let error: APIError = .invalidResponse
    /// print(error.errorDescription ?? "Unknown error")
    /// // Output: "Received invalid URL response"
    /// ```
    public var errorDescription: String? {
        switch self {
        case let .responseError(statusCode, data):
            return "ResponseError \(statusCode), data: " + (String(data: data, encoding: .utf8) ?? "nil")
        case .invalidResponse:
            return "Received invalid URL response"
        case .urlError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            switch error {
            case let .keyNotFound(key, context):
                return "Failed to decode response, missing key \"\(key.stringValue)\" with path: " + codingPathToString(context.codingPath)
            case .dataCorrupted(let context):
                return "Failed to decode corrupted response data at " + codingPathToString(context.codingPath) + ": " + context.debugDescription
            case let .typeMismatch(_, context):
                return context.debugDescription + " Path: " + codingPathToString(context.codingPath)
            case let .valueNotFound(valueType, context):
                return "Expected value of type \(valueType) at " + codingPathToString(context.codingPath) + " but not found."
            @unknown default:
                return error.localizedDescription
            }
        case .failedToEncodePlainText(let encoding):
            return "Failed to encode plain text body using encoding: \(encoding)"
        case .unknown(let error):
            return "Unknown Error: " + error.localizedDescription
        }
    }

    /// Converts a coding path to a string representation.
    ///
    /// This method takes a coding path, which is an array of `CodingKey` objects, and converts it to a string representation.
    /// The resulting string is a dot-separated list of the keys in the coding path.
    ///
    /// - Parameter codingPath: The coding path to convert.
    /// - Returns: A string representation of the coding path.
    private func codingPathToString(_ codingPath: [CodingKey]) -> String {
        codingPath
            .map { item in
                if let val = item.intValue {
                    return val.description
                }
                return item.stringValue
            }
            .joined(separator: ".")
    }
}
