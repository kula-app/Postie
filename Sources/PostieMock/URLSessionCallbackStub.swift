import Combine
import Foundation
import Postie

public class URLSessionCallbackStub: URLSessionProvider {
    private var result: (data: Data?, response: URLResponse?, error: Error?)
    private var urlRequestHandler: (URLRequest) -> Void

    public init(response: (data: Data?, response: URLResponse?), urlRequestHandler: @escaping (URLRequest) -> Void = { _ in }) {
        self.result = (response.data, response.response, nil)
        self.urlRequestHandler = urlRequestHandler
    }

    public init(throwsError error: Error, urlRequestHandler: @escaping (URLRequest) -> Void = { _ in }) {
        self.result = (nil, nil, error)
        self.urlRequestHandler = urlRequestHandler
    }

    public func send(urlRequest request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlRequestHandler(request)
        completion(result.data, result.response, result.error)
    }

    public func send(urlRequest _: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        fatalError("not available")
    }

    public func send(urlRequest _: URLRequest) async throws -> (Data, URLResponse) {
        fatalError("not available")
    }
}
