import Foundation
import PostieUtils
import URLEncodedFormCoding

internal struct ResponseDecoding: Decoder {

    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any] = [:]
    var response: HTTPURLResponse
    var data: Data

    init(response: HTTPURLResponse, data: Data, codingPath: [CodingKey] = []) {
        self.response = response
        self.data = data
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
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
        if #available(iOS 13.0, *) {
            return response.value(forHTTPHeaderField: header)
        } else {
            return response.allHeaderFields[header] as? String
        }
    }

    func decodeBody<E: Decodable>(to type: Array<E>.Type) throws -> [E] {
        fatalError()
    }

    func decodeBody<T: Decodable>(to type: T.Type) throws -> T {
        if type is FormURLEncodedDecodable.Type {
            return try createFormURLEncodedDecoder().decode(type, from: data)
        }
        if type is PlainDecodable.Type {
            return try decodeString(type, from: data)
        }
        if type is JSONDecodable.Type {
            return try createJSONDecoder().decode(type, from: data)
        }

        if type is CollectionProtocol.Type {
            guard let collectionType = type as? CollectionProtocol.Type else {
                preconditionFailure("this cast should not fail, contact the developers!")
            }
            let elementType = collectionType.getElementType()

            if elementType is FormURLEncodedDecodable.Type {
                return try createFormURLEncodedDecoder().decode(type, from: data)
            }
            if elementType is PlainDecodable.Type {
                return try decodeString(type, from: data)
            }
            if elementType is JSONDecodable.Type {
                return try createJSONDecoder().decode(type, from: data)
            }
        }
        fatalError("Unsupported body type: \(type)")
    }

    private func createJSONDecoder() -> JSONDecoder {
        let decoder = LoggingJSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //        switch dateFormat {
        //        case .iso8601:
        //            decoder.dateDecodingStrategy = .iso8601
        //        case .iso8601Full:
        //            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        //        }
        return decoder
    }

    private func createFormURLEncodedDecoder() -> URLEncodedFormDecoder {
        let decoder = URLEncodedFormDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private func decodeString<T>(_ type: T.Type, from data: Data) throws -> T {
        let encoding: String.Encoding = .utf8

        guard let value = String(data: data, encoding: encoding) as? T else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Failed to decode using encoding: \(encoding)")
            )
        }
        return value
    }
}
