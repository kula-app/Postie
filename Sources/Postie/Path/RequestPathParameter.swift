/// Protocol used for untyped access to the embedded value
internal protocol RequestPathParameterProtocol {

    /// Custom name of the path parameter, can be nil
    var name: String? { get }

    /// Path parameter value which should be rserialized and inserted into the path
    var untypedValue: RequestPathParameterValue { get }

}

@propertyWrapper
public struct RequestPathParameter<T> where T: RequestPathParameterValue {

    public var name: String?
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(name: String?, defaultValue: T) {
        self.name = name
        self.wrappedValue = defaultValue
    }

    public static func getParameterType() -> Any.Type {
        return T.self
    }
}

extension RequestPathParameter: RequestPathParameterProtocol {

    internal var untypedValue: RequestPathParameterValue {
        wrappedValue
    }
}

extension RequestPathParameter where T == String {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension RequestPathParameter where T == Int {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = -1
    }
}

extension RequestPathParameter: Encodable where T: Encodable {}

extension RequestPathParameter: ExpressibleByNilLiteral where T: ExpressibleByNilLiteral {

    public init(nilLiteral: ()) {
        self.wrappedValue = nil
    }
}

extension RequestPathParameter: ExpressibleByStringLiteral,
                                ExpressibleByExtendedGraphemeClusterLiteral,
                                ExpressibleByUnicodeScalarLiteral where T == String {

    public typealias ExtendedGraphemeClusterLiteralType = String.ExtendedGraphemeClusterLiteralType
    public typealias UnicodeScalarLiteralType = String.UnicodeScalarLiteralType
    public typealias StringLiteralType = String.StringLiteralType

    public init(stringLiteral value: String) {
        wrappedValue = value
    }
}

extension RequestPathParameter: ExpressibleByIntegerLiteral where T == Int {

    public init(integerLiteral value: IntegerLiteralType) {
        wrappedValue = value
    }
}
