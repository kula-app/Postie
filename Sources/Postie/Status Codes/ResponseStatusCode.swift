import Foundation

/// A property wrapper that provides a convenient way to handle response status codes.
///
/// The `ResponseStatusCode` struct is a property wrapper that allows you to specify the status code for a response.
/// It wraps the `UInt16` type and provides a default value of `0`.
///
/// Example usage:
/// ```
/// @ResponseStatusCode var statusCode: UInt16
/// ```
@propertyWrapper
public struct ResponseStatusCode: Decodable {
    /// The wrapped value representing the status code.
    ///
    /// This property holds the `UInt16` value that is managed by this property wrapper.
    public var wrappedValue: UInt16

    /// The projected value representing the HTTP status code.
    ///
    /// This property provides a convenient way to access the `HTTPStatusCode` value corresponding to the wrapped value.
    public var projectedValue: HTTPStatusCode? {
        HTTPStatusCode(rawValue: wrappedValue)
    }

    /// Initializes a new instance of `ResponseStatusCode` with the default value of `0`.
    ///
    /// Example usage:
    /// ```
    /// @ResponseStatusCode var statusCode: UInt16 = 0
    /// ```
    public init() {
        self.wrappedValue = 0
    }

    /// Initializes a new instance of `ResponseStatusCode` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the status code.
    ///
    /// Example usage:
    /// ```
    /// @ResponseStatusCode var statusCode: UInt16 = 200
    /// ```
    public init(wrappedValue: UInt16) {
        self.wrappedValue = wrappedValue
    }
}
