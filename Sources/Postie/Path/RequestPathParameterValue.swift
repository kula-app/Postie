public protocol RequestPathParameterValue {

    var serialized: String { get }
}

extension String: RequestPathParameterValue {
    public var serialized: String { self }
}

extension Int: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Int16: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Int32: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Int64: RequestPathParameterValue {
    public var serialized: String { description }
}

extension Optional: RequestPathParameterValue where Wrapped: RequestPathParameterValue {
    public var serialized: String {
      if let value = self {
        return value.serialized
      }
      return "nil"
    }
}
