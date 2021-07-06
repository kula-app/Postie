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

extension QueryItem where T == String {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension QueryItem: Encodable where T: Encodable {}
