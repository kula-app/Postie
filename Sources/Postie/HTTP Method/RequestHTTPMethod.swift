@propertyWrapper
public struct RequestHTTPMethod: Encodable {

    public var wrappedValue: HTTPMethod

    public init(wrappedValue: HTTPMethod = .get) {
        self.wrappedValue = wrappedValue
    }
}
