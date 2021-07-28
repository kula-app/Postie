import Foundation
#if canImport(Combine)
import Combine
#endif

public protocol URLSessionProvider {

    #if canImport(Combine)
    @available(iOS 13.0, *)
    func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    #endif

    func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)

}

extension URLSession: URLSessionProvider {

    #if canImport(Combine)
    @available(iOS 13.0, *)
    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
    #endif
    
    public func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
