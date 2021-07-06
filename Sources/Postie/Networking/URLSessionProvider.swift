import Foundation
import Combine

@available(iOS 13.0, *)
public protocol URLSessionProvider {

    func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)

}

@available(iOS 13.0, *)
extension URLSession: URLSessionProvider {

    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }

    public func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
