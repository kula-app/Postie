internal protocol RequestHeaderProtocol {
    /// Custom name of the header item, can be nil
    var name: String? { get }

    /// Header value which should be serialized
    var untypedValue: RequestHeaderValue { get }
}

@propertyWrapper
public struct RequestHeader<T> where T: RequestHeaderValue {
    public var name: String?
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(name: String? = nil, defaultValue: T) {
        self.name = name
        wrappedValue = defaultValue
    }
}

extension RequestHeader where T == String {
    public init(name: String?) {
        self.name = name
        wrappedValue = ""
    }
}

extension RequestHeader where T == String? {
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
