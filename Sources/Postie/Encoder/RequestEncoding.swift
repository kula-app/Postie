import Foundation

internal class RequestEncoding: Encoder {

    var parent: RequestEncoding?
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any] = [:]

    private(set) var customURL: URL?
    private(set) var httpMethod: HTTPMethod = .get
    private(set) var path: String = ""
    private(set) var queryItems: [URLQueryItem] = []
    private(set) var headers: [String: String] = [:]
    private(set) var pathParameters: [String: RequestPathParameterValue] = [:]
    private(set) var cookies: [HTTPCookie] = []
    private(set) var cachePolicy: URLRequest.CachePolicy?

    init(parent: RequestEncoding? = nil, codingPath: [CodingKey] = []) {
        self.parent = parent
        self.codingPath = codingPath
    }

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        let container = RequestKeyedEncodingContainer(for: self, keyedBy: type, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        RequestSingleValueEncodingContainer(encoder: self, codingPath: codingPath)
    }

    func setCustomURL(url: URL) {
        if let parent = parent {
            parent.setCustomURL(url: url)
        } else {
            customURL = url
        }
    }

    func addQueryItem(name: String, value: String?) {
        if let parent = parent {
            parent.addQueryItem(name: name, value: value)
        } else {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
    }

    func setHeader(name: String, value: String?) {
        if let parent = parent {
            parent.setHeader(name: name, value: value)
        } else {
            headers[name] = value
        }
    }

    func setPath(_ path: String) {
        if let parent = parent {
            parent.setPath(path)
        } else {
            self.path = path
        }
    }

    func setHttpMethod(_ httpMethod: HTTPMethod) {
        if let parent = parent {
            parent.setHttpMethod(httpMethod)
        } else {
            self.httpMethod = httpMethod
        }
    }

    func setPathParameter(key: String, value: RequestPathParameterValue) {
        if let parent = parent {
            parent.setPathParameter(key: key, value: value)
        } else {
            pathParameters[key] = value
        }
    }

    func setCookies(_ cookies: [HTTPCookie]) {
        if let parent = parent {
            parent.setCookies(cookies)
        } else {
            self.cookies += cookies
        }
    }

    func setCachePolicy(_ cachePolicy: URLRequest.CachePolicy) {
        if let parent = parent {
            parent.setCachePolicy(cachePolicy)
        } else {
            self.cachePolicy = cachePolicy
        }
    }

    // MARK: - Accessors

    func resolvedPath() throws -> String {
        return pathParameters.reduce(path) { partialResult, parameter in
            let key = parameter.key
            let value = parameter.value
            let replacement = value.serialized

            return partialResult.replacingOccurrences(of: "{\(key)}", with: replacement)
        }
    }
}
