/// A type that has a default format of plain text
public protocol PlainFormatProvider {
    /// Format of data, default extension is set to `.plain`
    static var format: APIDataFormat { get }
}

extension PlainFormatProvider {
    public static var format: APIDataFormat {
        .plain
    }
}

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
    /// The associated type representing the body of the plain text data.
    ///
    /// This associated type must conform to the `Encodable` protocol.
    associatedtype Body: Encodable

    /// The body of the plain text data.
    ///
    /// This property holds the body of the plain text data.
    var body: Body { get }

    /// The encoding used for the plain text data.
    ///
    /// This property holds the encoding used for the plain text data.
    var encoding: String.Encoding { get }
}
