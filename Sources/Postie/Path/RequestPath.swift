/// A property wrapper that provides a convenient way to handle request paths.
///
/// The `RequestPath` struct is a property wrapper that allows you to specify the path for a request.
/// It wraps a `String` value and provides a default value of an empty string.
///
/// Example usage:
/// ```
/// @RequestPath var path: String
/// ```
@propertyWrapper
public struct RequestPath: Encodable {
    /// The wrapped value representing the request path.
    ///
    /// This property holds the `String` value that is managed by this property wrapper.
    public var wrappedValue: String

    /// Initializes a new instance of `RequestPath` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the request path. Defaults to an empty string.
    ///
    /// Example usage:
    /// ```
    /// @RequestPath var path: String = "/api/v1/resource"
    /// ```
    public init(wrappedValue: String = "") {
        self.wrappedValue = wrappedValue
    }
}

extension RequestPath: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
    /// Initializes a new instance of `RequestPath` with the specified string literal.
    public typealias ExtendedGraphemeClusterLiteralType = String.ExtendedGraphemeClusterLiteralType
    /// Initializes a new instance of `RequestPath` with the specified string literal.
    public typealias UnicodeScalarLiteralType = String.UnicodeScalarLiteralType
    /// Initializes a new instance of `RequestPath` with the specified string literal.
    public typealias StringLiteralType = String.StringLiteralType

    /// Initializes a new instance of `RequestPath` with the specified string literal.
    ///
    /// - Parameter value: The string literal to initialize the `RequestPath` with.
    ///
    /// Example usage:
    /// ```
    /// @RequestPath var path: String = "/api/v1/resource"
    /// ```
    public init(stringLiteral value: String) {
        wrappedValue = value
    }
}
