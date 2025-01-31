import Foundation

/// Protocol used for untyped access to the embedded value
internal protocol RequestPathParameterProtocol {
    /// Custom name of the path parameter, can be nil
    var name: String? { get }

    /// Path parameter value which should be serialized and inserted into the path
    var untypedValue: RequestPathParameterValue { get }
}

/// A property wrapper that provides a convenient way to handle path parameters in a request.
///
/// Example usage:
/// ```
/// @RequestPathParameter var userId: String
/// ```
/// This property wrapper can be used to manage path parameters in a request.
@propertyWrapper
public struct RequestPathParameter<T> where T: RequestPathParameterValue {
    /// The custom name of the path parameter, can be nil.
    ///
    /// This property holds the custom name of the path parameter, which can be nil.
    public var name: String?
    /// The wrapped value representing the path parameter value.
    ///
    /// This property holds the wrapped value representing the path parameter value.
    public var wrappedValue: T

    /// Initializes a new instance of `RequestPathParameter` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the path parameter value.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter var userId: String = "123"
    /// ```
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    /// Initializes a new instance of `RequestPathParameter` with the specified name and default value.
    ///
    /// - Parameters:
    ///   - name: The custom name of the path parameter, can be nil.
    ///   - defaultValue: The default value representing the path parameter value.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter(name: "userId") var userId: String = "123"
    /// ```
    public init(name: String?, defaultValue: T) {
        self.name = name
        self.wrappedValue = defaultValue
    }

    /// Returns the type of the path parameter.
    ///
    /// - Returns: The type of the path parameter.
    public static func getParameterType() -> Any.Type {
        T.self
    }
}

extension RequestPathParameter: RequestPathParameterProtocol {
    internal var untypedValue: RequestPathParameterValue {
        wrappedValue
    }
}

extension RequestPathParameter where T == String {
    /// Initializes a new instance of `RequestPathParameter` with the specified name and an empty string as the default value.
    ///
    /// - Parameter name: The custom name of the path parameter, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter(name: "userId") var userId: String
    /// ```
    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension RequestPathParameter where T == Int {
    /// Initializes a new instance of `RequestPathParameter` with the specified name and a default value of -1.
    ///
    /// - Parameter name: The custom name of the path parameter, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter(name: "userId") var userId: Int
    /// ```
    public init(name: String?) {
        self.name = name
        self.wrappedValue = -1
    }
}

extension RequestPathParameter where T == Int16 {
    /// Initializes a new instance of `RequestPathParameter` with the specified name and a default value of -1.
    ///
    /// - Parameter name: The custom name of the path parameter, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter(name: "userId") var userId: Int16
    /// ```
    public init(name: String?) {
        self.name = name
        self.wrappedValue = -1
    }
}

extension RequestPathParameter where T == Int32 {
    /// Initializes a new instance of `RequestPathParameter` with the specified name and a default value of -1.
    ///
    /// - Parameter name: The custom name of the path parameter, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter(name: "userId") var userId: Int32
    /// ```
    public init(name: String?) {
        self.name = name
        self.wrappedValue = -1
    }
}

extension RequestPathParameter where T == Int64 {
    /// Initializes a new instance of `RequestPathParameter` with the specified name and a default value of -1.
    ///
    /// - Parameter name: The custom name of the path parameter, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @RequestPathParameter(name: "userId") var userId: Int64
    /// ```
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
    ExpressibleByUnicodeScalarLiteral
where T == String {
    public typealias ExtendedGraphemeClusterLiteralType = String.ExtendedGraphemeClusterLiteralType
    public typealias UnicodeScalarLiteralType = String.UnicodeScalarLiteralType
    public typealias StringLiteralType = String.StringLiteralType

    public init(stringLiteral value: String) {
        wrappedValue = value
    }
}

extension RequestPathParameter: ExpressibleByIntegerLiteral where T == IntegerLiteralType {
    public init(integerLiteral value: IntegerLiteralType) {
        wrappedValue = value
    }
}
