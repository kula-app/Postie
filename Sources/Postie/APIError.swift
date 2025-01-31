import Foundation

/// Represents various errors that can occur when interacting with the API.
public enum APIError: LocalizedError {
    /// Indicates a response error with a specific status code and data.
    case responseError(statusCode: Int, data: Data)
    /// Indicates an invalid response.
    case invalidResponse
    /// Indicates a URL error.
    case urlError(URLError)
    /// Indicates a decoding error.
    case decodingError(DecodingError)
    /// Indicates a failure to encode plain text with a specific encoding.
    case failedToEncodePlainText(encoding: String.Encoding)
    /// Indicates an unknown error.
    case unknown(error: Error)

    /// A localized message describing what error occurred.
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
