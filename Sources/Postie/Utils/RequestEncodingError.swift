import Foundation

enum RequestEncodingError: LocalizedError {
    case invalidBaseURL
    case failedToCreateURL
    case invalidCustomURL(URL)
}
