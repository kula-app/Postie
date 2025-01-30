public protocol RequestHeaderValue {
    var serializedHeaderValue: String? { get }
}

extension String: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        self
    }
}

extension Int: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        self.description
    }
}

extension Bool: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        self ? "true" : "false"
    }
}

extension Optional: RequestHeaderValue where Wrapped: RequestHeaderValue {
    public var serializedHeaderValue: String? {
        guard let value = self else { return nil }
        return value.serializedHeaderValue
    }
}
