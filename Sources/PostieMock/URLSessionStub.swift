import Foundation
import Combine
import Postie

public class URLSessionStub: URLSessionProvider {

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

    public func send(urlRequest request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        urlRequestHandler(request)
        return Future { promise in
            switch self.result {
            case .success(let output):
                promise(.success(output))
            case .failure(let error):
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    public func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlRequestHandler(request)
        switch self.result {
        case .success(let output):
            completion(output.data, output.response, nil)
        case .failure(let error):
            completion(nil, nil, error)
        }
    }
}
