import Foundation
import URLEncodedFormCoding
import Combine

public class RequestEncoder: TopLevelEncoder {
    
    let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func encode<Request>(_ request: Request) throws -> URLRequest where Request: Encodable {
        try encodeToBaseURLRequest(request)
    }

    // MARK: - JSON

    public func encodeJson<Request>(request: Request) throws -> URLRequest where Request: JSONEncodable {
        var urlRequest = try encodeToBaseURLRequest(request)
        urlRequest.httpBody = try encodeJsonBody(request.body)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }

    private func encodeJsonBody<Body: Encodable>(_ body: Body) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(body)
    }

    // MARK: - Form URL Encoded

    public func encodeFormURLEncoded<Request>(request: Request) throws -> URLRequest where Request: FormURLEncodedEncodable {
        var urlRequest = try encodeToBaseURLRequest(request)
        urlRequest.httpBody = try encodeFormURLEncodedBody(request.body)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }

    private func encodeFormURLEncodedBody<Body: Encodable>(_ body: Body) throws -> Data {
        let encoder = URLEncodedFormEncoder()
        return try encoder.encode(body)
    }

    // MARK: - Plain

    public func encodePlain<Request>(request: Request) throws -> URLRequest where Request: PlainEncodable {
        var urlRequest = try encodeToBaseURLRequest(request)
        urlRequest.httpBody = try encodePlainBody(request.body, encoding: request.encoding)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }

    private func encodePlainBody(_ body: String, encoding: String.Encoding) throws -> Data {
        guard let data = body.data(using: encoding) else {
            throw APIError.failedToEncodePlainText(encoding: encoding)
        }
        return data
    }

    // MARK: - Shared

    private func encodeToBaseURLRequest<Request: Encodable>(_ request: Request) throws -> URLRequest {
        let encoder = RequestEncoding()
        try request.encode(to: encoder)

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw RequestEncodingError.invalidBaseURL
        }
        components.path = encoder.path
        components.queryItems = encoder.queryItems
        guard let url = components.url else {
            throw RequestEncodingError.failedToCreateURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = encoder.httpMethod.rawValue
        request.allHTTPHeaderFields = encoder.headers
        return request
    }

    // MARK: - Legacy:

    // MARK: - URL Request

    /// Creates the `URLRequest` from the given `request` and the client configuration
    ///
    /// If the `request` provides a `predefinedUrl`, it is used instead of building one based on the configuration
    ///
    /// - Parameter request: request object implementing the `APIRequest` protocol
    /// - Throws: `APIError` if it is not possible to create an URL from the given query items
    /// - Returns: `URLRequest` object which can be used to communicate with the API endpoitn
//    func createURLRequest<Request: APIRequest>(for request: Request) throws -> URLRequest {
//        var urlRequest: URLRequest
//
//        // Check if the request has a predefined url
//        if let predefinedUrl = request.predefinedUrl {
//            urlRequest = URLRequest(url: predefinedUrl)
//        } else {
//            // Start of with base URL
//            var baseURL = self.url
//            // If a path prefix is given, append it to the base url
//            if let prefix = pathPrefix {
//                baseURL.appendPathComponent(prefix)
//            }
//            // Append the resource path
//            baseURL.appendPathComponent(request.resourcePath)
//
//            let encoder = RequestEncoder(baseURL: baseURL)
//            urlRequest = try encoder.encode(request: request)
//        }
//
//        // Create the URL request
//        urlRequest.allHTTPHeaderFields = request.headers
//        urlRequest.httpMethod = request.httpMethod
//
//        // If the request includeds a body payload, set it to the request body
//        if let payloadRequest = request as? APIPayloadRequest {
//            urlRequest.httpBody = payloadRequest.body
//        }
//
//        // Apply caching policy if cache should not be used
//        if !request.useCachedResponse {
//            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
//        }
//
//        return urlRequest
//    }
}
