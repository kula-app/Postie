public protocol RequestPathParameterValue {

    var serialized: String { get }
}

extension String: RequestPathParameterValue {
    public var serialized: String { self }
}

extension Int: RequestPathParameterValue {
    public var serialized: String { self.description }
}

extension Optional: RequestPathParameterValue where Wrapped: RequestPathParameterValue {
    public var serialized: String {
        if let value = self {
            return value.serialized
        }
        return "nil"
    }
}
