/* swiftlint:disable line_length */
import Foundation
import Combine
import os.log

@available(iOS 13.0, *)
open class HTTPAPIClient {

    public private(set) var session: URLSessionProvider
    public var url: URL
    public var pathPrefix: String?

    public init(url: URL, pathPrefix: String? = nil, session: URLSessionProvider = URLSession.shared) {
        self.url = url
        self.pathPrefix = pathPrefix
        self.session = session
    }

    // MARK: - Callbacks

    open func send<R: Request>(_ request: R, callback: @escaping (Result<R.Response, Error>) -> Void) {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: url)
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encode(request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: R.Response.self, urlRequest: urlRequest, callback: callback)
    }

    open func send<Request: JSONRequest>(_ request: Request, callback: @escaping (Result<Request.Response, Error>) -> Void) {
        var baseURL = url
        // Append the path prefix if given
        if let prefix = pathPrefix {
            baseURL.appendPathComponent(prefix)
        }
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: baseURL)
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeJson(request: request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest, callback: callback)
    }

    open func send<Request: FormURLEncodedRequest>(_ request: Request, callback: @escaping (Result<Request.Response, Error>) -> Void){
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: url)
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodeFormURLEncoded(request: request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest, callback: callback)
    }

    open func send<Request: PlainRequest>(_ request: Request, callback: @escaping (Result<Request.Response, Error>) -> Void) {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: url)
        // Encode request
        let urlRequest: URLRequest
        do {
            urlRequest = try encoder.encodePlain(request: request)
        } catch {
            // If encoding fails, exit immediately
            return callback(.failure(error))
        }
        log(request: request, urlRequest)
        return sendUrlRequest(responseType: Request.Response.self, urlRequest: urlRequest, callback: callback)
    }

    private func sendUrlRequest<Response: Decodable>(responseType: Response.Type, urlRequest: URLRequest, callback: @escaping (Result<Response, Error>) -> Void) {
        // Send request using the given URL session provider
        session.dataTask(with: urlRequest, completion: { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else {
                return callback(.failure(APIError.invalidResponse))
            }
            do {
                let decoder = ResponseDecoder()
                let decoded = try decoder.decode(Response.self, from: (data: data, response: response))
                callback(.success(decoded))
            } catch {
                callback(.failure(error))
            }
        })
    }

    // MARK: - Combine

    open func send<R: Request>(_ request: R) -> AnyPublisher<R.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: url)
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

    open func send<Request: JSONRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        var baseURL = url
        // Append the path prefix if given
        if let prefix = pathPrefix {
            baseURL.appendPathComponent(prefix)
        }
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: baseURL)
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

    open func send<Request: FormURLEncodedRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: url)
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

    open func send<Request: PlainRequest>(_ request: Request) -> AnyPublisher<Request.Response, Error> {
        // Create a request encoder
        let encoder = RequestEncoder(baseURL: url)
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

    private func sendUrlRequest<Response: Decodable>(responseType: Response.Type, urlRequest: URLRequest) -> AnyPublisher<Response, Error> {
        // Send request using the given URL session provider
        return session
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

    // MARK: - Logging

    /// Logs an `Request` and the generated `URLRequest`
    ///
    /// - Parameters:
    ///   - request: request conforming to the `Request` protocol
    ///   - urlRequest: generated `urlRequest` with is sent to the endpoint
    fileprivate func log<Request>(request: Request, _ urlRequest: URLRequest) {
        os_log(.debug, "[%@] Sending request of type %@ to URL: %@", urlRequest.httpMethod!, String(describing: type(of: request)), urlRequest.url!.absoluteString)
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
