import Foundation

/// A property wrapper that provides a convenient way to handle HTTP cookies in a request.
@propertyWrapper
public struct RequestCookies {
    /// The wrapped value representing an array of `HTTPCookie` objects.
    public var wrappedValue: [HTTPCookie]

    /// Initializes a new instance of `RequestCookies` with an optional array of `HTTPCookie` objects.
    ///
    /// - Parameter wrappedValue: An array of `HTTPCookie` objects. Defaults to an empty array.
    public init(wrappedValue: [HTTPCookie] = []) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: Encodable

extension RequestCookies: Encodable {
    /// Encodes this value into the given encoder.
    ///
    /// This method should never be called because `HTTPCookie` does not conform to `Encodable`.
    /// If called, it will cause a runtime failure.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: A runtime error indicating that this method should not be called.
    public func encode(to encoder: Encoder) throws {
        preconditionFailure("\(Self.self).encode(to encoder:) should not be called")
    }
}
