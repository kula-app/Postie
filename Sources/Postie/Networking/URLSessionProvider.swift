import Foundation
import Combine

@available(iOS 13.0, *)
public protocol URLSessionProvider {

    func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>

}

@available(iOS 13.0, *)
extension URLSession: URLSessionProvider {

    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
