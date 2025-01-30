@propertyWrapper
public struct NestedResponse<Response: Decodable> {
    public var wrappedValue: Response

    public init(wrappedValue: Response) {
        self.wrappedValue = wrappedValue
    }
}

extension NestedResponse: Decodable {
    public init(from decoder: Decoder) throws {
        wrappedValue = try Response(from: decoder)
    }
}
