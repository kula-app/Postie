import Combine
import Foundation

/// A protocol that provides methods for sending URL requests using different mechanisms.
///
/// The `URLSessionProvider` protocol defines methods for sending URL requests using Combine, callbacks, and async-await.
/// It allows for flexibility in handling URL requests and responses.
public protocol URLSessionProvider {
    /// Sends a URL request using Combine and returns a publisher that emits the response.
    ///
    /// - Parameter request: The URL request to send.
    /// - Returns: A publisher that emits the response data and URL response, or an error.
    ///
    /// Example usage:
    /// ```
    /// let provider: URLSessionProvider = URLSession.shared
    /// let publisher = provider.send(urlRequest: myRequest)
    /// publisher.sink(receiveCompletion: { completion in
    ///     switch completion {
    ///     case .finished:
    ///         print("Request completed successfully")
    ///     case .failure(let error):
    ///         print("Request failed with error: \(error)")
    ///     }
    /// }, receiveValue: { output in
    ///     print("Received response: \(output.response)")
    ///     print("Received data: \(output.data)")
    /// })
    /// .store(in: &cancellables)
    /// ```
    func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>

    /// Sends a URL request using a callback to handle the response.
    ///
    /// - Parameters:
    ///   - request: The URL request to send.
    ///   - completion: The callback to handle the response.
    ///
    /// Example usage:
    /// ```
    /// let provider: URLSessionProvider = URLSession.shared
    /// provider.send(urlRequest: myRequest) { data, response, error in
    ///     if let error = error {
    ///         print("Request failed with error: \(error)")
    ///     } else if let response = response, let data = data {
    ///         print("Received response: \(response)")
    ///         print("Received data: \(data)")
    ///     }
    /// }
    /// ```
    func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)

    /// Sends a URL request using async-await and returns the response.
    ///
    /// - Parameter request: The URL request to send.
    /// - Returns: A tuple containing the response data and URL response.
    /// - Throws: An error if the request fails.
    ///
    /// Example usage:
    /// ```
    /// let provider: URLSessionProvider = URLSession.shared
    /// let (data, response) = try await provider.send(urlRequest: myRequest)
    /// print("Received response: \(response)")
    /// print("Received data: \(data)")
    /// ```
    func send(urlRequest request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProvider {
    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }

    public func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request, completionHandler: completion)
        task.resume()
    }

    public func send(urlRequest request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request)
    }
}
