import Foundation

public enum APIError: LocalizedError {
    case responseError(statusCode: Int, data: Data)
    case invalidResponse
    case urlError(URLError)
    case decodingError(DecodingError)
    case failedToEncodePlainText(encoding: String.Encoding)
    case unknown(error: Error)

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
