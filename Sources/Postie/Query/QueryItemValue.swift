public protocol QueryItemValue {

    var serializedQueryItem: String? { get }

    var isCollection: Bool { get }

    func iterateCollection(_ iterator: (QueryItemValue) -> Void)
}

extension String: QueryItemValue {

    public var serializedQueryItem: String? {
        self
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

extension Int: QueryItemValue {

    public var serializedQueryItem: String? {
        self.description
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

extension Bool: QueryItemValue {

    public var serializedQueryItem: String? {
        self ? "true" : "false"
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

extension Optional: QueryItemValue where Wrapped: QueryItemValue {

    public var serializedQueryItem: String? {
        guard let value = self else { return nil }
        return value.serializedQueryItem
    }

    public var isCollection: Bool {
        guard let value = self else { return false }
        return value.isCollection
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        guard let value = self else { return }
        return value.iterateCollection(iterator)
    }
}

extension Array: QueryItemValue where Element: QueryItemValue {

    public var serializedQueryItem: String? {
        fatalError("This method should not be called. Multiple query items should be added to the query individually")
    }

    public var isCollection: Bool {
        return true
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        forEach(iterator)
    }
}

extension Set: QueryItemValue where Element: QueryItemValue {

    public var serializedQueryItem: String? {
        fatalError("This method should not be called. Multiple query items should be added to the query individually")
    }

    public var isCollection: Bool {
        return true
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        forEach(iterator)
    }
}

extension QueryItemValue where Self: RawRepresentable, RawValue: QueryItemValue {

    public var serializedQueryItem: String? {
        self.rawValue.serializedQueryItem
    }

    public var isCollection: Bool {
        self.rawValue.isCollection
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        self.rawValue.iterateCollection(iterator)
    }
}
