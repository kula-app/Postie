public protocol QueryItemValue {

    var serializedQueryItem: String? { get }

    var isCollection: Bool { get }

    func iterateCollection(_ iterator: (QueryItemValue) -> Void)
}

// MARK: - Array + QueryItemValue

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

// MARK: - Bool + QueryItemValue

extension Bool: QueryItemValue {

    public var serializedQueryItem: String? {
        self ? "true" : "false"
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

// MARK: - Double + QueryItemValue

extension Double: QueryItemValue {

    public var serializedQueryItem: String? {
        description
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

// MARK: - Int + QueryItemValue

extension Int: QueryItemValue {

    public var serializedQueryItem: String? {
        description
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

// MARK: - String + QueryItemValue

extension String: QueryItemValue {

    public var serializedQueryItem: String? {
        self
    }

    public var isCollection: Bool { false }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        fatalError("Not supported")
    }
}

// MARK: - Optional + QueryItemValue

extension Optional: QueryItemValue where Wrapped: QueryItemValue {

    public var serializedQueryItem: String? {
        guard let value = self else {
            return nil
        }
        return value.serializedQueryItem
    }

    public var isCollection: Bool {
        guard let value = self else {
            return false
        }
        return value.isCollection
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        guard let value = self else {
            return
        }
        return value.iterateCollection(iterator)
    }
}

// MARK: - Set + QueryItemValue

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

public extension QueryItemValue where Self: RawRepresentable, RawValue: QueryItemValue {

    var serializedQueryItem: String? {
        rawValue.serializedQueryItem
    }

    var isCollection: Bool {
        rawValue.isCollection
    }

    func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        rawValue.iterateCollection(iterator)
    }
}
