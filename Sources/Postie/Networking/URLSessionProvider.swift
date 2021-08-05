import Foundation
import Combine

public protocol URLSessionProvider {

    @available(iOS 13.0, *)
    func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>

    func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)

}

extension URLSession: URLSessionProvider {

    @available(iOS 13.0, *)
    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }

    public func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
