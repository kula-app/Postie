import Foundation
#if canImport(Combine)
import Combine
#endif

public class URLEncodedFormEncoder: TopLevelEncoder {

    public enum DecodingError: LocalizedError {
        case failedToConvertUsingEncoding
    }

    public var encoding: String.Encoding

    public init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }

    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        let context = URLEncodedFormDataContext()
        let encoder = _URLEncodedFormEncoder(context: context)
        try value.encode(to: encoder)
        guard let data = contextToURLString(context).data(using: encoding) else {
            throw DecodingError.failedToConvertUsingEncoding
        }
        return data
    }

    func contextToURLString(_ context: URLEncodedFormDataContext) -> String {
        // Transform context data into URLQueryItems
        var items: [URLQueryItem] = []
        for (key, value) in context.fields {
            switch value {
            case .text(let value):
                items.append(URLQueryItem(name: key, value: value))
            case .list(let values):
                items += values.map { URLQueryItem(name: key, value: $0) }
            }
        }
        // Order items so unit testing can use static strings
        items.sort { lhs, rhs in
            lhs.name < rhs.name
        }
        // Use URLComponent for automatic query escaping
        var comps = URLComponents(string: "")!
        comps.queryItems = items
        return comps.url?.query ?? ""
    }
}

private final class _URLEncodedFormEncoder: Encoder {

    /// See `Encoder`
    var userInfo: [CodingUserInfoKey: Any] = [:]

    /// See `Encoder`
    let codingPath: [CodingKey]

    /// The data being decoded
    var context: URLEncodedFormDataContext

    /// Creates a new form url-encoded encoder
    init(context: URLEncodedFormDataContext, codingPath: [CodingKey] = []) {
        self.context = context
        self.codingPath = codingPath
    }

    /// See `Encoder`
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        .init(_URLEncodedFormKeyedEncoder<Key>(context: context, codingPath: codingPath))
    }

    /// See `Encoder`
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        _URLEncodedFormUnkeyedEncoder(context: context, codingPath: codingPath)
    }

    /// See `Encoder`
    func singleValueContainer() -> SingleValueEncodingContainer {
        _URLEncodedFormSingleValueEncoder(context: context, codingPath: codingPath)
    }
}

/// Private `SingleValueEncodingContainer`.
private final class _URLEncodedFormSingleValueEncoder: SingleValueEncodingContainer {

    /// See `SingleValueEncodingContainer`
    var codingPath: [CodingKey]

    /// The data being encoded
    let context: URLEncodedFormDataContext

    /// Creates a new single value encoder
    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    /// See `SingleValueEncodingContainer`
    func encodeNil() throws {
        // skip
    }

    /// See `SingleValueEncodingContainer`
    func encode<T>(_ value: T) throws where T: Encodable {
        if let convertible = value as? URLEncodedElementConvertible {
            try context.set(to: convertible.convertToURLEncodedElement(), at: codingPath)
        } else {
            let encoder = _URLEncodedFormEncoder(context: context, codingPath: codingPath)
            try value.encode(to: encoder)
        }
    }
}

/// Private `KeyedEncodingContainerProtocol`.
private final class _URLEncodedFormKeyedEncoder<K>: KeyedEncodingContainerProtocol where K: CodingKey {
    /// See `KeyedEncodingContainerProtocol`
    typealias Key = K

    /// See `KeyedEncodingContainerProtocol`
    var codingPath: [CodingKey]

    /// The data being encoded
    let context: URLEncodedFormDataContext

    /// Creates a new `_URLEncodedFormKeyedEncoder`.
    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    /// See `KeyedEncodingContainerProtocol`
    func encodeNil(forKey key: K) throws {
        // skip
    }

    /// See `KeyedEncodingContainerProtocol`
    func encode<T>(_ value: T, forKey key: K) throws where T: Encodable {
        if let convertible = value as? URLEncodedElementConvertible {
            try context.set(to: convertible.convertToURLEncodedElement(), at: codingPath + [key])
        } else {
            let encoder = _URLEncodedFormEncoder(context: context, codingPath: codingPath + [key])
            try value.encode(to: encoder)
        }
    }

    /// See `KeyedEncodingContainerProtocol`
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        .init(_URLEncodedFormKeyedEncoder<NestedKey>(context: context, codingPath: codingPath + [key]))
    }

    /// See `KeyedEncodingContainerProtocol`
    func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        _URLEncodedFormUnkeyedEncoder(context: context, codingPath: codingPath + [key])
    }

    /// See `KeyedEncodingContainerProtocol`
    func superEncoder() -> Encoder {
        _URLEncodedFormEncoder(context: context, codingPath: codingPath)
    }

    /// See `KeyedEncodingContainerProtocol`
    func superEncoder(forKey key: K) -> Encoder {
        _URLEncodedFormEncoder(context: context, codingPath: codingPath + [key])
    }

}

/// Private `UnkeyedEncodingContainer`.
private final class _URLEncodedFormUnkeyedEncoder: UnkeyedEncodingContainer {

    /// See `UnkeyedEncodingContainer`.
    var codingPath: [CodingKey]

    /// See `UnkeyedEncodingContainer`.
    var count: Int

    /// The data being encoded
    let context: URLEncodedFormDataContext

    /// Converts the current count to a coding key
    var index: CodingKey {
        return BasicKey(count)
    }

    /// Creates a new `_URLEncodedFormUnkeyedEncoder`.
    init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
        self.count = 0
    }

    /// See `UnkeyedEncodingContainer`.
    func encodeNil() throws {
        // skip
    }

    /// See UnkeyedEncodingContainer.encode
    func encode<T>(_ value: T) throws where T: Encodable {
        defer { count += 1 }
        if let convertible = value as? URLEncodedElementConvertible {
            try context.set(to: convertible.convertToURLEncodedElement(), at: codingPath + [index])
        } else {
            let encoder = _URLEncodedFormEncoder(context: context, codingPath: codingPath + [index])
            try value.encode(to: encoder)
        }
    }

    /// See UnkeyedEncodingContainer.nestedContainer
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        defer { count += 1 }
        return .init(_URLEncodedFormKeyedEncoder<NestedKey>(context: context, codingPath: codingPath + [index]))
    }

    /// See UnkeyedEncodingContainer.nestedUnkeyedContainer
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        defer { count += 1 }
        return _URLEncodedFormUnkeyedEncoder(context: context, codingPath: codingPath + [index])
    }

    /// See UnkeyedEncodingContainer.superEncoder
    func superEncoder() -> Encoder {
        defer { count += 1 }
        return _URLEncodedFormEncoder(context: context, codingPath: codingPath + [index])
    }
}
