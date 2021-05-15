import Foundation

/// Protocol defining necessary request parameter values and the expected result type
public protocol APIRequest {

    associatedtype Response: APIResponse

    var resourcePath: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get set }
    var query: [String: APIQueryValue] { get }

    var format: APIRequestFormat { get }

    var useCachedResponse: Bool { get }

    /// If the url is predefined for this request, it won't be built from `resourcePath` and `query` relative to the HTTPClient `baseURL`
    ///
    /// Ignored if returns `nil`, which is the default behaviour
    var predefinedUrl: URL? { get }
}

extension APIRequest {

    public var httpMethod: String { "GET" }
    public var useCachedResponse: Bool { true }
    public var predefinedUrl: URL? { nil }

}

public enum APIRequestFormat {
    case json
    case formURLEncoded
}

public protocol APIFullRequest {

    associatedtype Request: APIRequest

    var request: Request { get }

}
