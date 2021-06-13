@propertyWrapper
public struct QueryItem<T> where T: QueryItemValue {

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

extension QueryItem where T == String {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension QueryItem: Encodable where T: Encodable {}

extension QueryItem: ExpressibleByNilLiteral where T: ExpressibleByNilLiteral {

    public init(nilLiteral: ()) {
        self.wrappedValue = nil
    }
}

extension QueryItem: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral where T == String {

    public typealias ExtendedGraphemeClusterLiteralType = String.ExtendedGraphemeClusterLiteralType
    public typealias UnicodeScalarLiteralType = String.UnicodeScalarLiteralType
    public typealias StringLiteralType = String.StringLiteralType

    public init(stringLiteral value: String) {
        wrappedValue = value
    }
}
