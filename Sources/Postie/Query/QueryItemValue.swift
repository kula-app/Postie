public protocol QueryItemValue {
    /// The serialized value of the query item.
    ///
    /// This property represents the serialized value of the query item.
    /// It is used to convert the query item value into a string format suitable for URL query parameters.
    var serializedQueryItem: String? { get }

    /// Indicates whether the query item is a collection.
    ///
    /// This property is used to determine if the query item is a collection.
    var isCollection: Bool { get }

    /// Iterates over the elements of the collection.
    ///
    /// - Parameter iterator: A closure that is called for each element in the collection.
    ///
    /// This method is used to iterate over the elements of the collection.
    /// If the query item is not a collection, this method should not be called.
    func iterateCollection(_ iterator: (QueryItemValue) -> Void)
}

// MARK: - Array + QueryItemValue

extension Array: QueryItemValue where Element: QueryItemValue {
    public var serializedQueryItem: String? {
        fatalError("This method should not be called. Multiple query items should be added to the query individually")
    }

    public var isCollection: Bool {
        true
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
        true
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        forEach(iterator)
    }
}

extension QueryItemValue where Self: RawRepresentable, RawValue: QueryItemValue {
    public var serializedQueryItem: String? {
        rawValue.serializedQueryItem
    }

    public var isCollection: Bool {
        rawValue.isCollection
    }

    public func iterateCollection(_ iterator: (QueryItemValue) -> Void) {
        rawValue.iterateCollection(iterator)
    }
}
