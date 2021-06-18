import Foundation

enum RequestEncodingError: LocalizedError {
    case invalidBaseURL
    case failedToCreateURL
    case invalidCustomURL(URL)
    case invalidPathParameterName(String)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return "Invalid base URL"
        case .failedToCreateURL:
            return "Failed to create URL"
        case .invalidCustomURL(let url):
            return "Invalid custom URL: \(url)"
        case .invalidPathParameterName(let name):
            return "Invalid path parameter name: \(name)"
        }
    }
}
