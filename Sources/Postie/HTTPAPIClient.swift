/* swiftlint:disable line_length */
import Foundation
import Combine
import os.log

@available(iOS 13.0, *)
open class HTTPAPIClient: APIClient {

    public enum DateFormat {
        case iso8601
        case iso8601Full
    }

    public private(set) var session: URLSessionProvider
    public var url: URL
    public var pathPrefix: String?

    public var dateFormat: DateFormat = .iso8601

    public init(url: URL, pathPrefix: String? = nil, session: URLSessionProvider = URLSession.shared) {
        self.url = url
        self.pathPrefix = pathPrefix
        self.session = session
    }

    open func send<Request: APIRequest>(_ request: Request) -> AnyPublisher<Request.Response, APIError> {
        let urlRequest: URLRequest
        do {
            urlRequest = try createURLRequest(for: request)
        } catch {
            preconditionFailure("Failed to create URL request: " + error.localizedDescription)
        }
        log(request: request, urlRequest)

        switch request.format {
        case .formURLEncoded:
            let decoder = createFormURLDecoder()
            return send(urlRequest: urlRequest, decoder: decoder, responseType: Request.Response.self)
        case .json:
            let decoder = createJSONDecoder()
            return send(urlRequest: urlRequest, decoder: decoder, responseType: Request.Response.self)
        }
    }

    open func send<Request: APIRequest>(_ request: Request) -> AnyPublisher<Request.Response, APIError> where Request.Response: APIFormURLEncodedResponse {
        let urlRequest: URLRequest
        do {
            urlRequest = try createURLRequest(for: request)
        } catch {
            preconditionFailure("Failed to create URL request: " + error.localizedDescription)
        }
        log(request: request, urlRequest)

        let decoder = createFormURLDecoder()
        return send(urlRequest: urlRequest, decoder: decoder, responseType: Request.Response.self)
    }

    open func send<Request: APIRequest>(_ request: Request) -> AnyPublisher<Request.Response, APIError> where Request.Response: APIJSONResponse {
        let urlRequest: URLRequest
        do {
            urlRequest = try createURLRequest(for: request)
        } catch {
            preconditionFailure("Failed to create URL request: " + error.localizedDescription)
        }
        log(request: request, urlRequest)

        let decoder = createJSONDecoder()
        return send(urlRequest: urlRequest, decoder: decoder, responseType: Request.Response.self)
    }

    private func send<Decoder: TopLevelDecoder, Body: Decodable>(urlRequest: URLRequest, decoder: Decoder, responseType: Body.Type) -> AnyPublisher<Body, APIError> where Decoder.Input == Data {
        session.send(urlRequest: urlRequest)
            .tryMap { (data, response) -> Body in
                try self.processResponse(body: Body.self, data: data, response: response, urlRequest: urlRequest, decoder: decoder).body
            }
            .mapError { error in
                HTTPAPIClient.processResponse(error: error, urlRequest: urlRequest)
            }
            .eraseToAnyPublisher()
    }

    open func sendWithFullResponse<Request: APIRequest>(_ request: Request) -> AnyPublisher<APIFullResponse<Request.Response>, APIError> where Request.Response: APIJSONResponse {
        let urlRequest: URLRequest
        do {
            urlRequest = try createURLRequest(for: request)
        } catch {
            preconditionFailure("Failed to create URL request: " + error.localizedDescription)
        }
        log(request: request, urlRequest)
        return sendWithFullResponse(urlRequest: urlRequest, decoder: createJSONDecoder(), responseType: Request.Response.self)
    }

    private func sendWithFullResponse<Decoder: TopLevelDecoder, Body: Decodable>(urlRequest: URLRequest, decoder: Decoder, responseType: Body.Type) -> AnyPublisher<APIFullResponse<Body>, APIError> where Decoder.Input == Data {
        session.send(urlRequest: urlRequest)
            .tryMap { (data, response) -> APIFullResponse<Body> in
                let (headers, body) = try self.processResponse(body: Body.self, data: data, response: response, urlRequest: urlRequest, decoder: decoder)
                return APIFullResponse(headers: headers, body: body)
            }
            .mapError { error in
                HTTPAPIClient.processResponse(error: error, urlRequest: urlRequest)
            }
            .eraseToAnyPublisher()
    }

    // MARK: - URL Request

    /// Creates the `URLRequest` from the given `request` and the client configuration
    ///
    /// If the `request` provides a `predefinedUrl`, it is used instead of building one based on the configuration
    ///
    /// - Parameter request: request object implementing the `APIRequest` protocol
    /// - Throws: `APIError` if it is not possible to create an URL from the given query items
    /// - Returns: `URLRequest` object which can be used to communicate with the API endpoitn
    func createURLRequest<Request: APIRequest>(for request: Request) throws -> URLRequest {
        let url: URL
        // Check if the request has a predefined url
        if let predefinedUrl = request.predefinedUrl {
            url = predefinedUrl
        } else {
            // Start of with base URL
            var baseURL = self.url
            // If a path prefix is given, append it to the base url
            if let prefix = pathPrefix {
                baseURL.appendPathComponent(prefix)
            }
            // Append the resource path
            baseURL.appendPathComponent(request.resourcePath)

            // Get all query parameters from the url
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            var queryItems = [URLQueryItem]()
            for (key, item) in request.query {
                switch item {
                case .string(let value):
                    queryItems.append(URLQueryItem(name: key, value: value))
                case .array(let values):
                    queryItems += values.map { value in
                        URLQueryItem(name: key, value: value)
                    }
                case .set(let values):
                    queryItems += values.map { value in
                        URLQueryItem(name: key, value: value)
                    }
                }
            }
            components?.queryItems = queryItems

            // Create the url from the path and query parameters
            // If this fails, the user has provided invalid resource data and an error should be thrown
            guard let builtUrl = components?.url else {
                throw APIError.invalidURL(url: baseURL, query: request.query)
            }
            url = builtUrl
        }

        // Create the URL request
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.httpMethod

        // If the request includeds a body payload, set it to the request body
        if let payloadRequest = request as? APIPayloadRequest {
            urlRequest.httpBody = payloadRequest.body
        }

        // Apply caching policy if cache should not be used
        if !request.useCachedResponse {
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        }

        return urlRequest
    }

    // MARK: - Response Handling

    private func processResponse<Body: Decodable, Decoder: TopLevelDecoder>(body: Body.Type, data: Data, response: URLResponse, urlRequest: URLRequest, decoder: Decoder) throws -> (headers: [AnyHashable: Any], body: Body) where Decoder.Input == Data {
        // Log the request
        self.log(urlRequest: urlRequest, response: response, data: data)
        // Check if response is an HTTP resposne ,and if the status code is valid
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw APIError.responseError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500, data: data)
        }
        let decoded = try decoder.decode(Body.self, from: data)
        return (httpResponse.allHeaderFields, decoded)
    }

    // MARK: - Error Handling

    private static func processResponse(error: Error, urlRequest: URLRequest) -> APIError {
        switch error {
        case let urlError as URLError:
            return .urlError(urlError)
        case let decodingError as DecodingError:
            os_log("Failed to decode object of request: %@, reason: %@", urlRequest.debugDescription, String(describing: decodingError))
            return .decodingError(decodingError)
        case let apiError as APIError:
            return apiError
        default:
            return .unknown(error: error)
        }
    }

    // MARK: - Decoders

    func createJSONDecoder() -> JSONDecoder {
        let decoder = LoggingJSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        switch dateFormat {
        case .iso8601:
            decoder.dateDecodingStrategy = .iso8601
        case .iso8601Full:
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        }
        return decoder
    }

    func createFormURLDecoder() -> URLEncodedFormDecoder {
        let decoder = URLEncodedFormDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    // MARK: - Logging

    /// Logs an `APIRequest` and the generated `URLRequest`
    ///
    /// - Parameters:
    ///   - request: request conforming to the `APIRequest` protocol
    ///   - urlRequest: generated `urlRequest` with is sent to the endpoint
    fileprivate func log<Request: APIRequest>(request: Request, _ urlRequest: URLRequest) {
        os_log(.debug, "Sending HTTP %s API request at URL: %s with headers: %@", request.httpMethod, urlRequest.url!.absoluteString, urlRequest.allHTTPHeaderFields?.description ?? "nil")
    }

    /// Logs a request with the received response and data
    ///
    /// - Parameters:
    ///   - urlRequest: `URLRequest` sent to the remote endpoint
    ///   - response: `URLResponse` received from the remote endpoint
    ///   - data: `Data` received from the remote endpoint
    fileprivate func log(urlRequest: URLRequest, response: URLResponse, data: Data) {
        let responseStatus = (response as? HTTPURLResponse)?.statusCode.description ?? "?"
        let dataCount = data.count.description
        let requestHttpMethod = urlRequest.httpMethod ?? "?"
        let requestUrl = urlRequest.url?.absoluteString ?? "?"
        os_log(.debug, "Received HTTP status %s with %s as response for HTTP %s %s",
               responseStatus,
               dataCount,
               requestHttpMethod,
               requestUrl)
    }

    // MARK: - Helpers

    /// Strips sensitive headers
    ///
    /// Sensitive headers include:
    ///
    ///     - Authorization
    ///
    /// - Parameter headers: HTTP header key-value pairs
    /// - Returns: sanitized header HTTP key-value pairs
    private func strippedSensitiveHeaders(from headers: [String: String]) -> [String: String] {
        var headers = headers
        // List of known sensitive headers
        let sensitiveHeaderKeys = [
            "Authorization"
        ]
        // Check for insensitive headers
        for key in headers.keys where sensitiveHeaderKeys.contains(where: { $0.compare(key, options: .caseInsensitive) == .orderedSame }) {
            headers[key] = "REDACTED"
        }
        // Return sanitized headers
        return headers
    }

}
