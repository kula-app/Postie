import Combine
import Foundation
import PostieUtils

open class URLEncodedFormDecoder: TopLevelDecoder {
    public enum DecodingError: Error {
        case invalidData
    }

    public enum KeyDecodingStrategy {
        case useDefaultKeys
        case convertFromSnakeCase
    }

    public var keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys

    public init() {}

    open func decode<D>(_ decodable: D.Type, from data: Data) throws -> D where D: Decodable {
        let urlEncodedFormData = String(data: data, encoding: .utf8) ?? ""
        let context = URLEncodedFormDataContext()

        for rawElement in urlEncodedFormData.components(separatedBy: "&") where !rawElement.isEmpty {
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
            if let previous = context.fields[key] {
                switch previous {
                case .list(let els):
                    context.fields[key] = .list(els + [value])
                case .text(let text):
                    context.fields[key] = .list([text, value])
                }
            } else {
                context.fields[key] = .text(value)
            }
        }
        let decoder = _URLEncodedFormDecoder(context: context, codingPath: [])
        return try D(from: decoder)
    }
}

// swift-format-ignore: NoLeadingUnderscores
private final class _URLEncodedFormDecoder: Decoder {
    let codingPath: [CodingKey]

    var userInfo: [CodingUserInfoKey: Any] {
        [:]
    }
    let context: URLEncodedFormDataContext

    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        .init(_URLEncodedFormKeyedDecoder<Key>(context: context, codingPath: codingPath))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        _URLEncodedFormUnkeyedDecoder(context: context, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        _URLEncodedFormSingleValueDecoder(context: context, codingPath: codingPath)
    }
}

// swift-format-ignore: NoLeadingUnderscores
private final class _URLEncodedFormSingleValueDecoder: SingleValueDecodingContainer {
    let context: URLEncodedFormDataContext
    var codingPath: [CodingKey]

    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    func decodeNil() -> Bool {
        context.fields.get(at: codingPath) == nil
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard let element = context.fields.get(at: codingPath) else {
            fatalError("No element found at \(codingPath)")
        }
        switch element {
        case .text(let content):
            guard let castedText = content as? T else {
                throw DecodingError.typeMismatch(
                    T.self,
                    .init(
                        codingPath: codingPath,
                        debugDescription: "Failed to decode String to type " + String(describing: T.self)
                    )
                )
            }
            return castedText
        default:
            let decoder = _URLEncodedFormDecoder(context: context, codingPath: codingPath)
            return try T(from: decoder)
        }
    }
}

// swift-format-ignore: NoLeadingUnderscores
private final class _URLEncodedFormKeyedDecoder<Key>: KeyedDecodingContainerProtocol where Key: CodingKey {
    let context: URLEncodedFormDataContext
    var codingPath: [CodingKey]

    var allKeys: [Key] {
        context.fields.keys.compactMap { Key(stringValue: $0) }
    }

    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    func contains(_ key: Key) -> Bool {
        fatalError("Contains not implemented")  // return context.data.get(at: codingPath)?.dictionary?[key.stringValue] != nil
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        fatalError("Decoding nil not implemented")  // return context.data.get(at: codingPath + [key]) == nil
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        let decoder = _URLEncodedFormDecoder(context: context, codingPath: codingPath + [key])
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey>
    where NestedKey: CodingKey {
        .init(_URLEncodedFormKeyedDecoder<NestedKey>(context: context, codingPath: codingPath + [key]))
    }

    /// See `KeyedDecodingContainerProtocol.`
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        _URLEncodedFormUnkeyedDecoder(context: context, codingPath: codingPath + [key])
    }

    /// See `KeyedDecodingContainerProtocol.`
    func superDecoder() throws -> Decoder {
        _URLEncodedFormDecoder(context: context, codingPath: codingPath)
    }

    /// See `KeyedDecodingContainerProtocol.`
    func superDecoder(forKey key: Key) throws -> Decoder {
        _URLEncodedFormDecoder(context: context, codingPath: codingPath + [key])
    }
}

// swift-format-ignore: NoLeadingUnderscores
private final class _URLEncodedFormUnkeyedDecoder: UnkeyedDecodingContainer {
    let context: URLEncodedFormDataContext

    var codingPath: [CodingKey]

    var count: Int? {
        guard let element = context.fields.get(at: codingPath), case URLEncodedElement.list(let values) = element else {
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
        BasicKey(currentIndex)
    }

    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
        currentIndex = 0
    }

    func decodeNil() throws -> Bool {
        fatalError("Decoding nil not implemented")  // return context.data.get(at: codingPath + [index]) == nil
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
        .init(_URLEncodedFormKeyedDecoder<NestedKey>(context: context, codingPath: codingPath + [index]))
    }

    /// See `UnkeyedDecodingContainer`.
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        _URLEncodedFormUnkeyedDecoder(context: context, codingPath: codingPath + [index])
    }

    /// See `UnkeyedDecodingContainer`.
    func superDecoder() throws -> Decoder {
        defer { currentIndex += 1 }
        return _URLEncodedFormDecoder(context: context, codingPath: codingPath + [index])
    }
}

extension Dictionary where Key == String, Value == URLEncodedElement {
    func get(at path: [CodingKey]) -> Value? {
        guard let key = path.first?.stringValue else {
            return nil
        }
        return self[key]
    }
}

extension Array where Element == URLEncodedElement {
    func get(at path: [CodingKey]) -> Element? {
        guard let index = path.first?.intValue else {
            return nil
        }
        return self[index]
    }
}
