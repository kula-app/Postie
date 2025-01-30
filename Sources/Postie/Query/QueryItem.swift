internal protocol QueryItemProtocol {
    /// Custom name of the query item, can be nil
    var name: String? { get }

    /// Path parameter value which should be serialized and appended to the URL
    var untypedValue: QueryItemValue { get }
}

@propertyWrapper
public struct QueryItem<T> where T: QueryItemValue {
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

// MARK: - Encodable

extension QueryItem: Encodable where T: Encodable {}

// MARK: - QueryItemProtocol

extension QueryItem: QueryItemProtocol {
    var untypedValue: QueryItemValue {
        wrappedValue
    }
}

extension QueryItem where T == Bool {
    public init(name: String?) {
        self.name = name
        wrappedValue = false
    }
}

extension QueryItem where T == Bool? {
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

extension QueryItem where T == Double {
    public init(name: String?) {
        self.name = name
        wrappedValue = .zero
    }
}

extension QueryItem where T == Double? {
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

extension QueryItem where T == Int? {
    public init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

extension QueryItem where T == String {
    public init(name: String?) {
        self.name = name
        wrappedValue = ""
    }
}

extension QueryItem where T == String? {
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
    public init(name: String?) {
        self.init(defaultValue: .none)
        self.name = name
    }
}
