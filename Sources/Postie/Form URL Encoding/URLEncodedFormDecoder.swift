import Foundation
import Combine

public final class URLEncodedFormDecoder: TopLevelDecoder {

    public enum DecodingError: Error {
        case invalidData
    }

    public enum KeyDecodingStrategy {
        case useDefaultKeys
        case convertFromSnakeCase
    }

    var keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys

    public init() {}

    public func decode<D>(_ decodable: D.Type, from data: Data) throws -> D where D: Decodable {
        let urlEncodedFormData = String(data: data, encoding: .utf8) ?? ""
        var context: URLEncodedFormDecoderContext = [:]

        for rawElement in urlEncodedFormData.components(separatedBy: "&") {
            let comps = rawElement.components(separatedBy: "=")
            if comps.count < 2 {
                throw DecodingError.invalidData
            }
            let key: String
            if keyDecodingStrategy == .convertFromSnakeCase {
                key = comps[0].camelCaseFromSnakeCase
            } else {
                key = comps[0]
            }
            let value = comps[1]
            if let previous = context[key] {
                switch previous {
                case .list(let els):
                    context[key] = .list(els + [value])
                case .text(let text):
                    context[key] = .list([text, value])
                }
            } else {
                context[key] = .text(value)
            }
        }
        let decoder = _URLEncodedFormDecoder(context: context, codingPath: [])
        return try D(from: decoder)
    }
}

private final class _URLEncodedFormDecoder: Decoder {

    let codingPath: [CodingKey]

    var userInfo: [CodingUserInfoKey: Any] {
        return [:]
    }
    let context: URLEncodedFormDecoderContext

    init(context: URLEncodedFormDecoderContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return .init(_URLEncodedFormKeyedDecoder<Key>(context: context, codingPath: codingPath))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return _URLEncodedFormUnkeyedDecoder(context: context, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return _URLEncodedFormSingleValueDecoder(context: context, codingPath: codingPath)
    }
}

private final class _URLEncodedFormSingleValueDecoder: SingleValueDecodingContainer {

    let context: URLEncodedFormDecoderContext

    var codingPath: [CodingKey]

    init(context: URLEncodedFormDecoderContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    func decodeNil() -> Bool {
        return context.get(at: codingPath) == nil
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard let element = context.get(at: codingPath) else {
            fatalError()
        }
        switch element {
        case .text(let content):
            guard let castedText = content as? T else {
                throw DecodingError.typeMismatch(T.self, .init(codingPath: codingPath, debugDescription: "Failed to decode String to type " + String(describing: T.self)))
            }
            return castedText
        default:
            let decoder = _URLEncodedFormDecoder(context: context, codingPath: codingPath)
            return try T.init(from: decoder)
        }
    }
}

private final class _URLEncodedFormKeyedDecoder<K>: KeyedDecodingContainerProtocol where K: CodingKey {

    typealias Key = K

    let context: URLEncodedFormDecoderContext

    var codingPath: [CodingKey]

    var allKeys: [K] {
        context.keys.compactMap { K(stringValue: $0) }
    }

    init(context: URLEncodedFormDecoderContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    func contains(_ key: K) -> Bool {
        fatalError() // return context.data.get(at: codingPath)?.dictionary?[key.stringValue] != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        fatalError()// return context.data.get(at: codingPath + [key]) == nil
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        let decoder = _URLEncodedFormDecoder(context: context, codingPath: codingPath + [key])
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey {
        return .init(_URLEncodedFormKeyedDecoder<NestedKey>(context: context, codingPath: codingPath + [key]))
    }

    /// See `KeyedDecodingContainerProtocol.`
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        return _URLEncodedFormUnkeyedDecoder(context: context, codingPath: codingPath + [key])
    }

    /// See `KeyedDecodingContainerProtocol.`
    func superDecoder() throws -> Decoder {
        return _URLEncodedFormDecoder(context: context, codingPath: codingPath)
    }

    /// See `KeyedDecodingContainerProtocol.`
    func superDecoder(forKey key: K) throws -> Decoder {
        return _URLEncodedFormDecoder(context: context, codingPath: codingPath + [key])
    }
}

private final class _URLEncodedFormUnkeyedDecoder: UnkeyedDecodingContainer {

    let context: URLEncodedFormDecoderContext

    var codingPath: [CodingKey]

    var count: Int? {
        guard let element = context.get(at: codingPath), case URLEncodedElement.list(let values) = element else {
            return nil
        }
        return values.count
    }

    var isAtEnd: Bool {
        guard let count = self.count else {
            return true
        }
        return currentIndex >= count
    }

    var currentIndex: Int

    var index: CodingKey {
        return BasicKey(currentIndex)
    }

    init(context: URLEncodedFormDecoderContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
        currentIndex = 0
    }

    func decodeNil() throws -> Bool {
        fatalError() // return context.data.get(at: codingPath + [index]) == nil
    }

    /// See `UnkeyedDecodingContainer`.
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        defer { currentIndex += 1 }
        let decoder = _URLEncodedFormDecoder(context: context, codingPath: codingPath + [index])
        return try T(from: decoder)
    }

    /// See `UnkeyedDecodingContainer`.
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey {
        return .init(_URLEncodedFormKeyedDecoder<NestedKey>(context: context, codingPath: codingPath + [index]))
    }

    /// See `UnkeyedDecodingContainer`.
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return _URLEncodedFormUnkeyedDecoder(context: context, codingPath: codingPath + [index])
    }

    /// See `UnkeyedDecodingContainer`.
    func superDecoder() throws -> Decoder {
        defer { currentIndex += 1 }
        return _URLEncodedFormDecoder(context: context, codingPath: codingPath + [index])
    }
}

extension Dictionary where Key == String, Value == URLEncodedElement {

    func get(at path: [CodingKey]) -> Value? {
        if let key = path.first?.stringValue {
            return self[key]
        } else {
            return nil
        }
    }
}

extension Array where Element == URLEncodedElement {

    func get(at path: [CodingKey]) -> Element? {
        if let index = path.first?.intValue {
            return self[index]
        } else {
            return nil
        }
    }
}
