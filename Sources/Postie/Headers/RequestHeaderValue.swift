/// A type that can be used as a value for an HTTP header.
///
/// The `RequestHeaderValue` protocol defines a type that can be used as a value for an HTTP header.
/// It requires conforming types to provide a `serializedHeaderValue` property that returns a string representation of the header value.
public protocol RequestHeaderValue {
    /// The serialized value of the header.
    ///
    /// This property represents the serialized value of the header.
    /// It is used to convert the header value into a string format suitable for HTTP headers.
    var serializedHeaderValue: String? { get }
}

extension String: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        self
    }
}

extension Int: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        self.description
    }
}

extension Bool: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        self ? "true" : "false"
    }
}

extension Optional: RequestHeaderValue where Wrapped: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        guard let value = self else { return nil }
        return value.serializedHeaderValue
    }
}
