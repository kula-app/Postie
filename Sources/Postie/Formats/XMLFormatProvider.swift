import Foundation

/// A type that has a default format of xml
public protocol XMLFormatProvider {
    /// Format of data, default extension is set to `.xml`
    static var format: APIDataFormat { get }
}

extension XMLFormatProvider {
    public static var format: APIDataFormat {
        .xml
    }
}

/// A provider for XML body data.
///
/// The `XMLBodyProvider` protocol defines a type that provides a body for XML data.
/// It requires conforming types to specify an associated type `Body` that conforms to the `Encodable` protocol
/// and to provide a `body` property of that type.
///
/// Example usage:
/// ```
/// struct MyXMLRequest: XMLBodyProvider {
///     struct Body: Encodable {
///         let name: String
///         let age: Int
///     }
///
///     var body: Body
/// }
/// ```
public protocol XMLBodyProvider {
    /// The associated type representing the body of the XML data.
    ///
    /// This associated type must conform to the `Encodable` protocol.
    associatedtype Body: Encodable

    /// The body of the XML data.
    ///
    /// This property holds the body of the XML data.
    var body: Body { get }
}
