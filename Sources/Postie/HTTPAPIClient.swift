import Combine
import Foundation
import os.log

// swiftlint:disable file_length type_body_length
/// A class responsible for sending HTTP API requests and handling responses.
///
/// The `HTTPAPIClient` class provides methods to send HTTP API requests using different encoding formats
/// and handle the responses. It supports callbacks, async-await, and Combine for handling responses.
open class HTTPAPIClient {
    /// The URL session provider used for sending requests.
    public private(set) var session: URLSessionProvider
    /// The base URL for the API requests.
    public var url: URL
    /// An optional path prefix to be appended to the base URL.
    public var pathPrefix: String?

    /// Initializes a new instance of `HTTPAPIClient` with the specified URL, path prefix, and session provider.
    ///
    /// - Parameters:
    ///   - url: The base URL for the API requests.
    ///   - pathPrefix: An optional path prefix to be appended to the base URL.
    ///   - session: The URL session provider used for sending requests. Defaults to `URLSession.shared`.
    public init(url: URL, pathPrefix: String? = nil, session: URLSessionProvider = URLSession.shared) {
        self.url = url
        self.pathPrefix = pathPrefix
        self.session = session
    }

    // MARK: - Callbacks

    /// Sends an HTTP API request using a callback to handle the response.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - queue: An optional dispatch queue to receive the callback on. Defaults to `nil`.
    ///   - callback: The callback to handle the response.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myRequest) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         print("Received response: \(response)")
    ///     case .failure(let error):
    ///         print("Request failed with error: \(error)")
    ///     }
    /// }
    /// ```
    open func send<R: Request>(_ request: R, receiveOn queue: DispatchQueue? = nil, callback: @escaping (Result<R.Response, Error>) -> Void) {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encode(request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: R.Response.self, urlRequest: urlRequest, receiveOn: queue, callback: callback)
    }

    /// Sends an HTTP API request with a JSON body using a callback to handle the response.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - queue: An optional dispatch queue to receive the callback on. Defaults to `nil`.
    ///   - callback: The callback to handle the response.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myJsonRequest) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         print("Received response: \(response)")
    ///     case .failure(let error):
    ///         print("Request failed with error: \(error)")
    ///     }
    /// }
    /// ```
    open func send<Request: JSONRequest>(
        _ request: Request,
        receiveOn queue: DispatchQueue? = nil,
        callback: @escaping (
            Result<Request.Response, Error>
        ) -> Void
    ) {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeJson(request: request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest, receiveOn: queue, callback: callback)
    }

    /// Sends an HTTP API request with a Form URL Encoded body using a callback to handle the response.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - queue: An optional dispatch queue to receive the callback on. Defaults to `nil`.
    ///   - callback: The callback to handle the response.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myFormURLEncodedRequest) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         print("Received response: \(response)")
    ///     case .failure(let error):
    ///         print("Request failed with error: \(error)")
    ///     }
    /// }
    /// ```
    open func send<Request: FormURLEncodedRequest>(
        _ request: Request,
        receiveOn queue: DispatchQueue? = nil,
        callback: @escaping (
            Result<Request.Response, Error>
        ) -> Void
    ) {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest, receiveOn: queue, callback: callback)
    }

    /// Sends an HTTP API request with a plain text body using a callback to handle the response.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - queue: An optional dispatch queue to receive the callback on. Defaults to `nil`.
    ///   - callback: The callback to handle the response.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myPlainRequest) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         print("Received response: \(response)")
    ///     case .failure(let error):
    ///         print("Request failed with error: \(error)")
    ///     }
    /// }
    /// ```
    open func send<Request: PlainRequest>(
        _ request: Request,
        receiveOn queue: DispatchQueue? = nil,
        callback: @escaping (
            Result<Request.Response, Error>
        ) -> Void
    ) {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodePlain(request: request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest, receiveOn: queue, callback: callback)
    }

    /// Sends a URL request and handles the response using a callback.
    ///
    /// - Parameters:
    ///   - responseType: The type of the response to decode.
    ///   - urlRequest: The URL request to send.
    ///   - queue: An optional dispatch queue to receive the callback on. Defaults to `nil`.
    ///   - callback: The callback to handle the response.
    private func sendUrlRequest<Response: Decodable>(
        responseType: Response.Type,
        urlRequest: URLRequest,
        receiveOn queue: DispatchQueue?,
        callback: @escaping (
            Result<Response, Error>
        ) -> Void
    ) {
        // Send request using the given URL session provider
        session.send(urlRequest: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else {
                return callback(.failure(APIError.invalidResponse))
            }
            var syncBlock: () -> Void
            do {
                let decoder = ResponseDecoder()
                let decoded = try decoder.decode(Response.self, from: (data: data, response: response))
                syncBlock = {
                    callback(.success(decoded))
                }
            } catch {
                syncBlock = {
                    callback(.failure(error))
                }
            }
            if let queue = queue {
                queue.async(execute: syncBlock)
            } else {
                syncBlock()
            }
        }
    }

    // MARK: - Async-Await

    /// Sends an HTTP API request using async-await to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The decoded response.
    /// - Throws: An error if the request encoding or response decoding fails.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// let response = try await client.send(myRequest)
    /// print("Received response: \(response)")
    /// ```
    open func send<R: Request>(_ request: R) async throws -> R.Response {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encode(request)
        } catch {
            // If encoding fails, exit immediately
            throw error
        }
        log(request: request, urlRequest)
        return try await sendUrlRequest(responseType: R.Response.self, urlRequest: urlRequest)
    }

    /// Sends an HTTP API request with a JSON body using async-await to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The decoded response.
    /// - Throws: An error if the request encoding or response decoding fails.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// let response = try await client.send(myJsonRequest)
    /// print("Received response: \(response)")
    /// ```
    open func send<Request: JSONRequest>(_ request: Request) async throws -> Request.Response {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeJson(request: request)
        } catch {
            // If encoding fails, exit immediately
            throw error
        }
        log(request: request, urlRequest)
        return try await sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest)
    }

    /// Sends an HTTP API request with a Form URL Encoded body using async-await to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The decoded response.
    /// - Throws: An error if the request encoding or response decoding fails.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// let response = try await client.send(myFormURLEncodedRequest)
    /// print("Received response: \(response)")
    /// ```
    open func send<Request: FormURLEncodedRequest>(_ request: Request) async throws -> Request.Response {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            // If encoding fails, exit immediately
            throw error
        }
        log(request: request, urlRequest)
        return try await sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest)
    }

    /// Sends an HTTP API request with a plain text body using async-await to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The decoded response.
    /// - Throws: An error if the request encoding or response decoding fails.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// let response = try await client.send(myPlainRequest)
    /// print("Received response: \(response)")
    /// ```
    open func send<Request: PlainRequest>(_ request: Request) async throws -> Request.Response {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodePlain(request: request)
        } catch {
            // If encoding fails, exit immediately
            throw error
        }
        log(request: request, urlRequest)
        return try await sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest)
    }

    /// Sends a URL request and handles the response using async-await.
    ///
    /// - Parameters:
    ///   - responseType: The type of the response to decode.
    ///   - urlRequest: The URL request to send.
    /// - Returns: The decoded response.
    /// - Throws: An error if the response decoding fails.
    private func sendUrlRequest<Response: Decodable>(responseType: Response.Type, urlRequest: URLRequest) async throws -> Response {
        // Send request using the given URL session provider
        let (data, response) = try await session.send(urlRequest: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        let decoder = ResponseDecoder()
        return try decoder.decode(Response.self, from: (data: data, response: response))
    }

    // MARK: - Combine

    /// Sends an HTTP API request using Combine to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: A publisher that emits the decoded response or an error.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myRequest)
    ///     .sink(receiveCompletion: { completion in
    ///         switch completion {
    ///         case .finished:
    ///             print("Request completed successfully")
    ///         case .failure(let error):
    ///             print("Request failed with error: \(error)")
    ///         }
    ///     }, receiveValue: { response in
    ///         print("Received response: \(response)")
    ///     })
    ///     .store(in: &cancellables)
    /// ```
    open func send<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encode(request)
        } catch {
            // If encoding fails, exit immediately
            return Fail(error: error).eraseToAnyPublisher()
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: R.Response.self, urlRequest: urlRequest)
    }

    /// Sends an HTTP API request with a JSON body using Combine to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: A publisher that emits the decoded response or an error.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myJsonRequest)
    ///     .sink(receiveCompletion: { completion in
    ///         switch completion {
    ///         case .finished:
    ///             print("Request completed successfully")
    ///         case .failure(let error):
    ///             print("Request failed with error: \(error)")
    ///         }
    ///     }, receiveValue: { response in
    ///         print("Received response: \(response)")
    ///     })
    ///     .store(in: &cancellables)
    /// ```
    open func send<Request: JSONRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeJson(request: request)
        } catch {
            // If encoding fails, exit immediately
            return Fail(error: error).eraseToAnyPublisher()
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest)
    }

    /// Sends an HTTP API request with a Form URL Encoded body using Combine to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: A publisher that emits the decoded response or an error.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myFormURLEncodedRequest)
    ///     .sink(receiveCompletion: { completion in
    ///         switch completion {
    ///         case .finished:
    ///             print("Request completed successfully")
    ///         case .failure(let error):
    ///             print("Request failed with error: \(error)")
    ///         }
    ///     }, receiveValue: { response in
    ///         print("Received response: \(response)")
    ///     })
    ///     .store(in: &cancellables)
    /// ```
    open func send<Request: FormURLEncodedRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            // If encoding fails, exit immediately
            return Fail(error: error).eraseToAnyPublisher()
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest)
    }

    /// Sends an HTTP API request with a plain text body using Combine to handle the response.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: A publisher that emits the decoded response or an error.
    ///
    /// Example usage:
    /// ```
    /// let client = HTTPAPIClient(url: URL(string: "https://api.example.com")!)
    /// client.send(myPlainRequest)
    ///     .sink(receiveCompletion: { completion in
    ///         switch completion {
    ///         case .finished:
    ///             print("Request completed successfully")
    ///         case .failure(let error):
    ///             print("Request failed with error: \(error)")
    ///         }
    ///     }, receiveValue: { response in
    ///         print("Received response: \(response)")
    ///     })
    ///     .store(in: &cancellables)
    /// ```
    open func send<Request: PlainRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: prepareURL())
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodePlain(request: request)
        } catch {
            // If encoding fails, exit immediately
            return Fail(error: error).eraseToAnyPublisher()
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest)
    }

    /// Sends a URL request and handles the response using Combine.
    ///
    /// - Parameters:
    ///   - responseType: The type of the response to decode.
    ///   - urlRequest: The URL request to send.
    /// - Returns: A publisher that emits the decoded response or an error.
    private func sendUrlRequest<Response: Decodable>(responseType: Response.Type, urlRequest: URLRequest) -> AnyPublisher<Response, Error> {
        // Send request using the given URL session provider
        session
            .send(urlRequest: urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                return (data: data, response: response)
            }
            .decode(type: Response.self, decoder: ResponseDecoder())
            .eraseToAnyPublisher()
    }

    // MARK: - Logging

    /// Logs an `Request` and the generated `URLRequest`
    ///
    /// - Parameters:
    ///   - request: request conforming to the `Request` protocol
    ///   - urlRequest: generated `urlRequest` with is sent to the endpoint
    fileprivate func log<Request>(request: Request, _ urlRequest: URLRequest) {
        let requestHttpMethod = urlRequest.httpMethod ?? "?"
        let requestType = String(describing: type(of: request))
        let requestUrl = urlRequest.url?.absoluteString ?? "?"
        os_log(
            .debug,
            "[%@] Sending request of type %@ to URL: %@",
            requestHttpMethod,
            requestType,
            requestUrl
        )
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
        os_log(
            .debug,
            "Received HTTP status %s with %s as response for HTTP %s %s",
            responseStatus,
            dataCount,
            requestHttpMethod,
            requestUrl
        )
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

    /// Prepares the URL by applying relevant transformations
    ///
    /// - Returns: Transformed URL
    private func prepareURL() -> URL {
        // Append the path prefix if given
        guard let prefix = pathPrefix else {
            return url
        }
        return url.appendingPathComponent(prefix)
    }
}
// swiftlint:enable file_length type_body_length
