import Combine

public protocol APIClient {

    func send<Request: APIRequest>(_ request: Request) -> AnyPublisher<Request.Response, APIError> where Request.Response: APIFormURLEncodedResponse
    func send<Request: APIRequest>(_ request: Request) -> AnyPublisher<Request.Response, APIError> where Request.Response: APIJSONResponse

}
