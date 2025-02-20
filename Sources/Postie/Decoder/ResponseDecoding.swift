import Foundation
import PostieUtils
import URLEncodedFormCoding
import XMLCoder

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
        fatalError("not implemented")
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        ResponseSingleValueDecodingContainer(decoder: self, codingPath: codingPath)
    }

    func valueForHeaderCaseInsensitive<T>(_ header: String) -> T? {
        // Find case insensitive
        for (key, value) in response.allHeaderFields {
            guard let key = key.base as? String else {
                continue
            }
            let existingKey =
                key
                .split(separator: "-")
                .map(\.uppercasingFirst)
                .joined()
                .lowercased()

            if let value = value as? String, existingKey == header.lowercased() {
                switch T.self {
                case is IntegerLiteralType.Type,
                    is IntegerLiteralType?.Type:
                    return Int(value) as? T

                default:
                    return value as? T
                }
            }
        }
        return nil
    }

    func valueForHeaderCaseSensitive(_ header: String) -> String? {
        response.value(forHTTPHeaderField: header)
    }

    func decodeBody<E: Decodable>(to type: [E].Type) throws -> [E] {
        fatalError("not implemented")
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
        if type is XMLDecodable.Type {
            return try createXMLDecoder().decode(type, from: data)
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
            if elementType is XMLDecodable.Type {
                return try createXMLDecoder().decode(type, from: data)
            }
        }
        fatalError("Unsupported body type: \(type)")
    }

    private func createJSONDecoder() -> JSONDecoder {
        let decoder = LoggingJSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private func createFormURLEncodedDecoder() -> URLEncodedFormDecoder {
        let decoder = LoggingURLEncodedFormDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private func decodeString<T>(_ type: T.Type, from data: Data) throws -> T {
        let encoding: String.Encoding = .utf8

        guard let value = String(data: data, encoding: encoding) as? T else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Failed to decode using encoding: \(encoding)"
                )
            )
        }
        return value
    }

    private func createXMLDecoder() -> XMLDecoder {
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
