@propertyWrapper
public struct RequestHeader<T> where T: RequestHeaderValue {

    public var name: String?
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(name: String?, defaultValue: T) {
        self.name = name
        self.wrappedValue = defaultValue
    }
}

extension RequestHeader where T == String {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension RequestHeader: Encodable where T: Encodable {}

extension RequestHeader: ExpressibleByStringLiteral,
                         ExpressibleByExtendedGraphemeClusterLiteral,
                         ExpressibleByUnicodeScalarLiteral where T == String {

    public typealias ExtendedGraphemeClusterLiteralType = String.ExtendedGraphemeClusterLiteralType
    public typealias UnicodeScalarLiteralType = String.UnicodeScalarLiteralType
    public typealias StringLiteralType = String.StringLiteralType

    public init(stringLiteral value: String) {
        wrappedValue = value
    }
}
