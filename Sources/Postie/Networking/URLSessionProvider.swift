import Foundation
import Combine

public protocol URLSessionProvider {
    func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>

    func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)

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
