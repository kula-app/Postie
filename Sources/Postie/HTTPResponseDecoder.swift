import Foundation
import Combine

class HTTPResponseDecoder<BodyDecoder: Decoder>: TopLevelDecoder {

    typealias Input = Data

    let headers: [AnyHashable: Any]
    let bodyDecoder: BodyDecoder

    init(headers: [AnyHashable: Any], bodyDecoder: BodyDecoder) {
        self.headers = headers
        self.bodyDecoder = bodyDecoder
    }

    func decode<T>(_ type: T.Type, from: Input) throws -> T where T: Decodable {
        fatalError()
    }
}

// swiftlint:disable:next type_name
class _HTTPResponseDecoder: Decoder {

    let wrappedDecoder: Decoder

    init(wrappedDecoder: Decoder) {
        self.wrappedDecoder = wrappedDecoder
    }

    var codingPath: [CodingKey] {
        wrappedDecoder.codingPath
    }

    var userInfo: [CodingUserInfoKey: Any] {
        wrappedDecoder.userInfo
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        try wrappedDecoder.container(keyedBy: type)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try wrappedDecoder.unkeyedContainer()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        try wrappedDecoder.singleValueContainer()
    }

}

extension KeyedDecodingContainer {

    /// Optional date values can be nil, therefore overwrite the decode so it does not throw a missing key error
    func decode<T>(_ type: APIResponseHeader<T>.Type, forKey key: Self.Key) throws -> APIResponseHeader<T> {
        fatalError()
    }
}
