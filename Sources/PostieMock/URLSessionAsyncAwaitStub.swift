import Combine
import Foundation
import Postie

public class URLSessionAsyncAwaitStub: URLSessionProvider {
    private var result: Result<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    private var urlRequestHandler: (URLRequest) -> Void

    public init(response: URLSession.DataTaskPublisher.Output, urlRequestHandler: @escaping (URLRequest) -> Void = { _ in }) {
        self.result = .success(response)
        self.urlRequestHandler = urlRequestHandler
    }

    public init(throwsError error: URLSession.DataTaskPublisher.Failure, urlRequestHandler: @escaping (URLRequest) -> Void = { _ in }) {
        self.result = .failure(error)
        self.urlRequestHandler = urlRequestHandler
    }

    public func send(urlRequest request: URLRequest) async throws -> (Data, URLResponse) {
        urlRequestHandler(request)
        switch result {
        case let .success(output):
            return output
        case let .failure(error):
            throw error
        }
    }

    public func send(urlRequest _: URLRequest, completion _: @escaping (Data?, URLResponse?, Error?) -> Void) {
        fatalError("not available")
    }

    public func send(urlRequest _: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        fatalError("not available")
    }
}
