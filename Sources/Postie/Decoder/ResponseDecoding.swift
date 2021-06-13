import Foundation
import PostieUtils
import URLEncodedFormCoding

internal struct ResponseDecoding: Decoder {

    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any] = [:]
    var response: HTTPURLResponse
    var data: Data

    init(response: HTTPURLResponse, data: Data, codingPath: [CodingKey] = []) {
        self.response = response
        self.data = data
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = ResponseKeyedDecodingContainer(decoder: self, keyedBy: type, codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        ResponseSingleValueDecodingContainer(decoder: self, codingPath: codingPath)
    }

    func valueForHeaderCaseInsensitive(_ header: String) -> String? {
        // Find case insensitive
        for (key, value) in response.allHeaderFields {
            guard let key = key.base as? String else {
                continue
            }
            let existingKey = key
                .split(separator: "-")
                .map(\.uppercasingFirst)
                .joined()
                .lowercasingFirst
            if existingKey.lowercased() == header.lowercased() {
                return value as? String
            }
        }
        return nil
    }

    func valueForHeaderCaseSensitive(_ header: String) -> String? {
        response.value(forHTTPHeaderField: header)
    }

    func decodeBody<T: Decodable>(to type: T.Type) throws -> T {
        if type is FormURLEncodedDecodable.Type {
            let decoder = URLEncodedFormDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(type, from: data)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        switch dateFormat {
//        case .iso8601:
//            decoder.dateDecodingStrategy = .iso8601
//        case .iso8601Full:
//            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
//        }
        return try decoder.decode(type, from: data)
    }
}
