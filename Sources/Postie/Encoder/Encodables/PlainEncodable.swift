import Foundation

/// A type that should encode itself to a JSON representation.
public typealias PlainEncodable = Encodable & PlainFormatProvider & PlainBodyProvider

public protocol PlainBodyProvider {
    var body: String { get }
    var encoding: String.Encoding { get }
}

extension PlainBodyProvider {
    public var encoding: String.Encoding {
        .utf8
    }
}

extension String.Encoding: @retroactive Encodable {
}
