internal protocol QueryItemProtocol {
    /// Custom name of the query item, can be nil
    var name: String? { get }

    /// Path parameter value which should be serialized and appended to the URL
    var untypedValue: QueryItemValue { get }
}

/// A property wrapper that provides a convenient way to handle query items in a request.
///
/// Example usage:
/// ```
/// @QueryItem(name: "search") var searchQuery: String
/// ```
/// This property wrapper can be used to manage query items in a request.
@propertyWrapper
public struct QueryItem<T> where T: QueryItemValue {
    /// The custom name of the query item, can be nil.
    ///
    /// This property holds the custom name of the query item, which can be nil.
    public var name: String?
    /// The wrapped value representing the query item value.
    ///
    /// This property holds the wrapped value representing the query item value.
    public var wrappedValue: T

    /// Initializes a new instance of `QueryItem` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the query item value.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem var searchQuery: String = "example"
    /// ```
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    /// Initializes a new instance of `QueryItem` with the specified name and default value.
    ///
    /// - Parameters:
    ///   - name: The custom name of the query item, can be nil.
    ///   - defaultValue: The default value representing the query item value.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "search") var searchQuery: String = "example"
    /// ```
    public init(name: String? = nil, defaultValue: T) {
        self.name = name
        wrappedValue = defaultValue
    }
}

// MARK: - Encodable

extension QueryItem: Encodable where T: Encodable {}

// MARK: - QueryItemProtocol

extension QueryItem: QueryItemProtocol {
    var untypedValue: QueryItemValue {
        wrappedValue
    }
}

extension QueryItem where T == Bool {
    /// Initializes a new instance of `QueryItem` with the specified name and a default value of `false`.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "isActive") var isActive: Bool
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = false
    }
}

extension QueryItem where T == Bool? {
    /// Initializes a new instance of `QueryItem` with the specified name and a nil value as the default value.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "isActive") var isActive: Bool?
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

extension QueryItem where T == Double {
    /// Initializes a new instance of `QueryItem` with the specified name and a default value of `0.0`.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "price") var price: Double
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = .zero
    }
}

extension QueryItem where T == Double? {
    /// Initializes a new instance of `QueryItem` with the specified name and a nil value as the default value.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "price") var price: Double?
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

extension QueryItem where T == Int? {
    /// Initializes a new instance of `QueryItem` with the specified name and a nil value as the default value.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "count") var count: Int?
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

extension QueryItem where T == String {
    /// Initializes a new instance of `QueryItem` with the specified name and an empty string as the default value.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "search") var searchQuery: String
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = ""
    }
}

extension QueryItem where T == String? {
    /// Initializes a new instance of `QueryItem` with the specified name and a nil value as the default value.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "search") var searchQuery: String?
    /// ```
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

// MARK: - OptionalType

public protocol OptionalType {
    associatedtype Wrapped
    static var none: Self { get }
}

// MARK: - Optional + OptionalType

extension Optional: OptionalType {}

extension QueryItem where T: OptionalType, T.Wrapped: RawRepresentable {
    /// Initializes a new instance of `QueryItem` with the specified name and a nil value as the default value.
    ///
    /// - Parameter name: The custom name of the query item, can be nil.
    ///
    /// Example usage:
    /// ```
    /// @QueryItem(name: "status") var status: MyEnum?
    /// ```
    public init(name: String?) {
        self.init(defaultValue: .none)
        self.name = name
    }
}
