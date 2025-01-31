internal protocol RequestHeaderProtocol {
    /// Custom name of the header item, can be nil
    var name: String? { get }

    /// Header value which should be serialized
    var untypedValue: RequestHeaderValue { get }
}

/// A property wrapper that provides a convenient way to handle HTTP headers in a request.
@propertyWrapper
public struct RequestHeader<T> where T: RequestHeaderValue {
    /// The custom name of the header item, can be nil.
    public var name: String?
    /// The wrapped value representing the header value.
    public var wrappedValue: T

    /// Initializes a new instance of `RequestHeader` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the header value.
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    /// Initializes a new instance of `RequestHeader` with the specified name and default value.
    ///
    /// - Parameters:
    ///   - name: The custom name of the header item, can be nil.
    ///   - defaultValue: The default value representing the header value.
    public init(name: String? = nil, defaultValue: T) {
        self.name = name
        wrappedValue = defaultValue
    }
}

extension RequestHeader where T == String {
    /// Initializes a new instance of `RequestHeader` with the specified name and an empty string as the default value.
    ///
    /// - Parameter name: The custom name of the header item, can be nil.
    public init(name: String?) {
        self.name = name
        wrappedValue = ""
    }
}

extension RequestHeader where T == String? {
    /// Initializes a new instance of `RequestHeader` with the specified name and a nil value as the default value.
    ///
    /// - Parameter name: The custom name of the header item, can be nil.
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

// MARK: - Encodable

extension RequestHeader: Encodable where T: Encodable {}

// MARK: - RequestHeaderProtocol

extension RequestHeader: RequestHeaderProtocol {
    var untypedValue: RequestHeaderValue {
        wrappedValue
    }
}
