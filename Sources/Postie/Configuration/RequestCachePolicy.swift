import Foundation

/// A property wrapper that provides a convenient way to handle request cache policies.
///
/// The `RequestCachePolicy` struct is a property wrapper that allows you to specify the cache policy for a request.
/// It wraps the `URLRequest.CachePolicy` type and provides a default value of `.useProtocolCachePolicy`.
///
/// Example usage:
/// ```
/// @RequestCachePolicy var cachePolicy: URLRequest.CachePolicy
/// ```
@propertyWrapper
public struct RequestCachePolicy {
    /// The wrapped value representing the cache policy.
    ///
    /// This property holds the `URLRequest.CachePolicy` value that is managed by this property wrapper.
    public var wrappedValue: URLRequest.CachePolicy

    /// Initializes a new instance of `RequestCachePolicy` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the cache policy. Defaults to `.useProtocolCachePolicy`.
    ///
    /// Example usage:
    /// ```
    /// @RequestCachePolicy var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    /// ```
    public init(wrappedValue: URLRequest.CachePolicy = .useProtocolCachePolicy) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: - Encodable

extension RequestCachePolicy: Encodable {
    /// Encodes this value into the given encoder.
    ///
    /// This method should never be called because `URLRequest.CachePolicy` does not conform to `Encodable`.
    /// If called, it will cause a runtime failure.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: A runtime error indicating that this method should not be called.
    public func encode(to encoder: any Encoder) throws {
        preconditionFailure("\(Self.self).encode(to encoder:) should not be called")
    }
}
