/// A type that can be used as a value for a request path parameter.
///
/// The `RequestPathParameterValue` protocol defines a type that can be used as a value for a request path parameter.
/// It requires conforming types to provide a `serialized` property that returns a string representation of the path parameter value.
public protocol RequestPathParameterValue {
    /// The serialized value of the path parameter.
    ///
    /// This property represents the serialized value of the path parameter.
    /// It is used to convert the path parameter value into a string format suitable for URL paths.
    var serialized: String { get }
}

extension String: RequestPathParameterValue {
    public var serialized: String { self }
}

extension Int: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Int16: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Int32: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Int64: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Optional: RequestPathParameterValue where Wrapped: RequestPathParameterValue {
    public var serialized: String {
        if let value = self {
            return value.serialized
        }
        return "nil"
    }
}
