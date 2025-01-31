import Foundation

/// A type that should encode itself to a JSON representation.
public typealias JSONEncodable = Encodable & JSONFormatProvider & JSONBodyProvider

/// A protocol that provides the body and key encoding strategy for JSON encoding.
public protocol JSONBodyProvider {
    /// The type of the body to be encoded.
    associatedtype Body: Encodable

    /// The key encoding strategy to use for JSON encoding.
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }

    /// The body to be encoded.
    var body: Body { get }
}

extension JSONBodyProvider {
    /// The default key encoding strategy for JSON encoding.
    ///
    /// By default, this is set to `.convertToSnakeCase`.
    public var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        .convertToSnakeCase
    }
}
