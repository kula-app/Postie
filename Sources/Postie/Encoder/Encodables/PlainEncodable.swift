import Foundation

/// A type that should encode itself to a JSON representation.
public typealias PlainEncodable = Encodable & PlainFormatProvider & PlainBodyProvider

/// A provider for plain text body data.
///
/// The `PlainBodyProvider` protocol defines a type that provides a body for plain text data.
/// It requires conforming types to specify an associated type `Body` that conforms to the `Encodable` protocol
/// and to provide a `body` property of that type.
///
/// Example usage:
/// ```
/// struct MyPlainRequest: PlainBodyProvider {
///     struct Body: Encodable {
///         let content: String
///     }
///
///     var body: Body
///     var encoding: String.Encoding
/// }
/// ```
public protocol PlainBodyProvider {
    /// The body of the plain text data.
    ///
    /// This property holds the body of the plain text data.
    var body: String { get }

    /// The encoding used for the plain text data.
    ///
    /// This property holds the encoding used for the plain text data.
    var encoding: String.Encoding { get }
}

extension PlainBodyProvider {
    /// The encoding used for the plain text data.
    ///
    /// This property holds the encoding used for the plain text data.
    /// Default implementation is `.utf8`
    ///
    /// - Note: This property is required by the `PlainBodyProvider` protocol.
    public var encoding: String.Encoding {
        .utf8
    }
}

/// Extension to make `String.Encoding` conform to `Encodable`
extension String.Encoding: @retroactive Encodable {
}
