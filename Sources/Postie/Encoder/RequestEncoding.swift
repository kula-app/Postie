import Foundation

internal class RequestEncoding: Encoder {

    var parent: RequestEncoding?
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any] = [:]

    private(set) var customUrl: URL?
    private(set) var httpMethod: HTTPMethod = .get
    private(set) var path: String = ""
    private(set) var queryItems: [URLQueryItem] = []
    private(set) var headers: [String: String] = [:]
    private(set) var pathParameters: [String: RequestPathParameterValue] = [:]

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

    func setCustomUrl(url: URL) {
        if let parent = parent {
            parent.setCustomUrl(url: url)
        } else {
            customUrl = url
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

    // MARK: - Accessors

    func resolvedPath() throws -> String {
        let resolvedPath = NSMutableString(string: path)

        for (key, value) in pathParameters {
            let regex: NSRegularExpression
            do {
                regex = try NSRegularExpression(pattern: "\\{\(key)\\}", options: [])
            } catch {
                throw RequestEncodingError.invalidPathParameterName(key)
            }
            let replacement = value.serialized.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? value.serialized
            regex.replaceMatches(in: resolvedPath,
                                 options: [],
                                 range: NSRange(location: .zero, length: resolvedPath.length),
                                 withTemplate: replacement)
        }
        return resolvedPath as String
    }
}
