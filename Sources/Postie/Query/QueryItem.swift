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

    public init(defaultValue: T) {
        self.wrappedValue = defaultValue
    }

    public init(name: String?, defaultValue: T) {
        self.name = name
        self.wrappedValue = defaultValue
    }
}

extension QueryItem: QueryItemProtocol {

    var untypedValue: QueryItemValue {
        self.wrappedValue
    }
}

extension QueryItem where T == String {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension QueryItem where T == String? {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = nil
    }
}

extension QueryItem where T == Int? {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = nil
    }
}

extension QueryItem: Encodable where T: Encodable {}
