import Combine
import Foundation
import URLEncodedFormCoding
import XMLCoder

/// A class responsible for encoding HTTP requests into various formats.
///
/// The `RequestEncoder` class provides functionality to encode HTTP requests into different formats,
/// including JSON, Form URL Encoded, Plain, and XML. It uses the `RequestEncoding` encoder to perform
/// the encoding process.
public class RequestEncoder {
    /// The base URL for the requests.
    let baseURL: URL

    /// Initializes a new instance of `RequestEncoder` with the specified base URL.
    ///
    /// - Parameter baseURL: The base URL for the requests.
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    /// Encodes an HTTP request into a `URLRequest`.
    ///
    /// - Parameter request: The request to encode.
    /// - Returns: The encoded `URLRequest`.
    /// - Throws: An error if the encoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let encoder = RequestEncoder(baseURL: URL(string: "https://api.example.com")!)
    /// let urlRequest = try encoder.encode(myRequest)
    /// ```
    public func encode<Request>(_ request: Request) throws -> URLRequest where Request: Encodable {
        try encodeToBaseURLRequest(request)
    }

    // MARK: - JSON

    /// Encodes an HTTP request with a JSON body into a `URLRequest`.
    ///
    /// - Parameter request: The request to encode.
    /// - Returns: The encoded `URLRequest`.
    /// - Throws: An error if the encoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let encoder = RequestEncoder(baseURL: URL(string: "https://api.example.com")!)
    /// let urlRequest = try encoder.encodeJson(request: myJsonRequest)
    /// ```
    public func encodeJson<Request>(request: Request) throws -> URLRequest where Request: JSONEncodable {
        var urlRequest = try encodeToBaseURLRequest(request)
        urlRequest.httpBody = try encodeJsonBody(request.body, keyEncodingStrategy: request.keyEncodingStrategy)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }

    private func encodeJsonBody<Body: Encodable>(
        _ body: Body,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy
    ) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.outputFormatting = .sortedKeys
        return try encoder.encode(body)
    }

    // MARK: - Form URL Encoded

    /// Encodes an HTTP request with a Form URL Encoded body into a `URLRequest`.
    ///
    /// - Parameter request: The request to encode.
    /// - Returns: The encoded `URLRequest`.
    /// - Throws: An error if the encoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let encoder = RequestEncoder(baseURL: URL(string: "https://api.example.com")!)
    /// let urlRequest = try encoder.encodeFormURLEncoded(request: myFormURLEncodedRequest)
    /// ```
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

    /// Encodes an HTTP request with a plain text body into a `URLRequest`.
    ///
    /// - Parameter request: The request to encode.
    /// - Returns: The encoded `URLRequest`.
    /// - Throws: An error if the encoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let encoder = RequestEncoder(baseURL: URL(string: "https://api.example.com")!)
    /// let urlRequest = try encoder.encodePlain(request: myPlainRequest)
    /// ```
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

    // MARK: - XML

    /// Encodes an HTTP request with an XML body into a `URLRequest`.
    ///
    /// - Parameter request: The request to encode.
    /// - Returns: The encoded `URLRequest`.
    /// - Throws: An error if the encoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let encoder = RequestEncoder(baseURL: URL(string: "https://api.example.com")!)
    /// let urlRequest = try encoder.encodeXML(request: myXmlRequest)
    /// ```
    public func encodeXML<Request>(request: Request) throws -> URLRequest where Request: XMLEncodable {
        var urlRequest = try encodeToBaseURLRequest(request)
        urlRequest.httpBody = try encodeXMLBody(request.body)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }

    private func encodeXMLBody<Body: Encodable>(_ body: Body) throws -> Data {
        let encoder = XMLEncoder()
        return try encoder.encode(body)
    }

    // MARK: - Shared

    private func encodeToBaseURLRequest<Request: Encodable>(_ request: Request) throws -> URLRequest {
        let encoder = RequestEncoding()
        try request.encode(to: encoder)

        var components: URLComponents
        // If a customURL got defined, use that one and append query items
        if let url = encoder.customURL {
            guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw RequestEncodingError.invalidCustomURL(url)
            }
            components = comps
        } else {
            var url = baseURL
            // If given, append custom path to base url
            var path = try encoder.resolvedPath()
            // If the defined path starts with a leading slash, trim it
            if encoder.path.starts(with: "/") {
                path = String(path.dropFirst())
            }
            if !path.isEmpty {
                url = url.appendingPathComponent(path)
            }
            guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw RequestEncodingError.invalidBaseURL
            }
            components = comps
        }

        if !encoder.queryItems.isEmpty {
            // Existing URL query items should not be overwritten, as they might
            // be set by the custom URL
            if let existingItems = components.queryItems {
                for item in encoder.queryItems where !existingItems.contains(where: { $0.name == item.name }) {
                    components.queryItems = (components.queryItems ?? []) + [item]
                }
            } else {
                components.queryItems = encoder.queryItems
            }
        }
        guard let url = components.url else {
            throw RequestEncodingError.failedToCreateURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = encoder.httpMethod.rawValue
        request.allHTTPHeaderFields =
            HTTPCookie
            .requestHeaderFields(with: encoder.cookies)
            // Merge the Cookie headers with the custom headers, where custom headers have precedence
            .merging(encoder.headers) { $1 }
        if let cachePolicy = encoder.cachePolicy {
            request.cachePolicy = cachePolicy
        }
        return request
    }
}

// MARK: TopLevelEncoder

extension RequestEncoder: TopLevelEncoder {}
