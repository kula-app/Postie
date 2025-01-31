import Foundation

/// A property wrapper that provides a convenient way to handle request URLs.
///
/// The `RequestURL` struct is a property wrapper that allows you to specify the URL for a request.
/// It wraps a `URL?` value and provides a default value of `nil`.
///
/// Example usage:
/// ```
/// @RequestURL var url: URL?
/// ```
@propertyWrapper
public struct RequestURL: Encodable {
    /// The wrapped value representing the request URL.
    ///
    /// This property holds the `URL?` value that is managed by this property wrapper.
    public var wrappedValue: URL?

    /// Initializes a new instance of `RequestURL` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the request URL. Defaults to `nil`.
    ///
    /// Example usage:
    /// ```
    /// @RequestURL var url: URL? = URL(string: "https://api.example.com/resource")
    /// ```
    public init(wrappedValue: URL? = nil) {
        self.wrappedValue = wrappedValue
    }
}
