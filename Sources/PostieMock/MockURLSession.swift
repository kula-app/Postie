import Foundation
import Combine
import Postie

public class MockURLSession: URLSessionProvider {

    private var resultPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    private var urlRequestHandler: (URLRequest) -> Void

    public init(returnResponse: URLSession.DataTaskPublisher.Output, urlRequestHandler: @escaping (URLRequest) -> Void = { _ in }) {
        self.resultPublisher = Future { promise in
            promise(.success(returnResponse))
        }.eraseToAnyPublisher()
        self.urlRequestHandler = urlRequestHandler
    }

    public init(throwsError error: URLSession.DataTaskPublisher.Failure, urlRequestHandler: @escaping (URLRequest) -> Void = { _ in }) {
        self.resultPublisher = Fail(error: error).eraseToAnyPublisher()
        self.urlRequestHandler = urlRequestHandler
    }

    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        urlRequestHandler(request)
        return resultPublisher
    }
}
