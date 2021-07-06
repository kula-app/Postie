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

    public init(defaultValue: T) {
        self.init(name: nil, defaultValue: defaultValue)
    }
}

extension RequestHeader where T == String {

    public init(name: String?) {
        self.name = name
        self.wrappedValue = ""
    }
}

extension RequestHeader: Encodable where T: Encodable {}
