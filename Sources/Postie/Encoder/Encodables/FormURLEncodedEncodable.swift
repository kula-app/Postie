/// A type that can decode itself from an external form-url encoded representation.
public typealias FormURLEncodedEncodable = Encodable & FormURLEncodedFormatProvider & FormURLEncodedBodyProvider

/// A provider for form URL encoded body data.
///
/// The `FormURLEncodedBodyProvider` protocol defines a type that provides a body for form URL encoded data.
/// It requires conforming types to specify an associated type `Body` that conforms to the `Encodable` protocol
/// and to provide a `body` property of that type.
///
/// Example usage:
/// ```
/// struct MyFormURLEncodedRequest: FormURLEncodedBodyProvider {
///     struct Body: Encodable {
///         let name: String
///         let age: Int
///     }
///
///     var body: Body
/// }
/// ```
public protocol FormURLEncodedBodyProvider {
    /// The associated type representing the body of the form URL encoded data.
    ///
    /// This associated type must conform to the `Encodable` protocol.
    associatedtype Body: Encodable

    /// The body of the form URL encoded data.
    ///
    /// This property holds the body of the form URL encoded data.
    var body: Body { get }
}
