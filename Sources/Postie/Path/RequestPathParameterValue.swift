public protocol RequestPathParameterValue {

    var serialized: String { get }
}

extension String: RequestPathParameterValue {
    public var serialized: String { self }
}
extension Int: RequestPathParameterValue {
    public var serialized: String { self.description }
}
