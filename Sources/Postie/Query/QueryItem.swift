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

public extension QueryItem where T == Bool {

    init(name: String? = nil) {
        self.name = name
        wrappedValue = false
    }
}

public extension QueryItem where T == Bool? {

    init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

public extension QueryItem where T == Double {

    init(name: String?) {
        self.name = name
        wrappedValue = .zero
    }
}

public extension QueryItem where T == Double? {

    init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

public extension QueryItem where T == Int? {

    init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

public extension QueryItem where T == String {

    init(name: String?) {
        self.name = name
        wrappedValue = ""
    }
}

public extension QueryItem where T == String? {

    init(name: String?) {
        self.name = name
        wrappedValue = nil
    }
}

// MARK: - OptionalType

public protocol OptionalType {
    associatedtype Wrapped
    static var none: Self { get }
}

// MARK: - OptionalType

extension Optional: OptionalType {}

public extension QueryItem where T: OptionalType, T.Wrapped: RawRepresentable {

    init(name: String?) {
        self.init(defaultValue: .none)
        self.name = name
    }
}
