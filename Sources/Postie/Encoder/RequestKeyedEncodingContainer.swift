import Foundation

class RequestKeyedEncodingContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {

    var codingPath: [CodingKey]
    let encoder: RequestEncoding

    init(for encoder: RequestEncoding, keyedBy type: Key.Type, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }

    func encodeNil(forKey key: Key) throws {
        encoder.addQueryItem(name: key.stringValue, value: nil)
    }

    // swiftlint:disable cyclomatic_complexity function_body_length
    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        switch value {
        case let queryItem as QueryItemProtocol:
            let queryItemValue = queryItem.untypedValue
            if queryItemValue.isCollection {
                queryItemValue.iterateCollection { item in
                    if let value = item.serializedQueryItem {
                        encoder.addQueryItem(name: queryItem.name ?? key.stringValue, value: value)
                    }
                }
            } else if let itemValue = queryItemValue.serializedQueryItem {
                encoder.addQueryItem(name: queryItem.name ?? key.stringValue, value: itemValue)
            }
        case let queryItem as QueryItem<[String]>:
            for value in queryItem.wrappedValue {
                encoder.addQueryItem(name: queryItem.name ?? key.stringValue, value: value)
            }
        case let header as RequestHeader<String>:
            encoder.setHeader(name: header.name ?? key.stringValue, value: header.wrappedValue)
        case let header as RequestHeader<Int>:
            encoder.setHeader(name: header.name ?? key.stringValue, value: header.wrappedValue.description)
        case let header as RequestHeader<Bool>:
            encoder.setHeader(name: header.name ?? key.stringValue, value: header.wrappedValue ? "true" : "false")
        case let header as RequestHeader<String?>:
            if let value = header.wrappedValue {
                encoder.setHeader(name: header.name ?? key.stringValue, value: value)
            }
        case let header as RequestHeader<Int?>:
            if let value = header.wrappedValue {
                encoder.setHeader(name: header.name ?? key.stringValue, value: value.description)
            }
        case let header as RequestHeader<Bool?>:
            if let value = header.wrappedValue {
                encoder.setHeader(name: header.name ?? key.stringValue, value: value ? "true" : "false")
            }

        case let param as RequestPathParameterProtocol:
            encoder.setPathParameter(key: param.name ?? key.stringValue,
                                     value:param.untypedValue.serialized)
        case let path as RequestPath:
            encoder.setPath(path.wrappedValue)
        case let method as RequestHTTPMethod:
            encoder.setHttpMethod(method.wrappedValue)
        case let url as RequestUrl:
            guard let customUrl = url.wrappedValue else {
                break
            }
            encoder.setCustomUrl(url: customUrl)
        default:
            // ignore any other values
            break
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key)
        -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        RequestEncoding(parent: encoder, codingPath: [key]).container(keyedBy: keyType)
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        RequestEncoding(parent: encoder, codingPath: [key]).unkeyedContainer()
    }

    func superEncoder() -> Encoder {
        encoder
    }

    func superEncoder(forKey key: Key) -> Encoder {
        encoder
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    fileprivate var isNil: Bool {
        self == nil
    }
}
