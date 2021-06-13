@propertyWrapper
public struct ResponseErrorBody<Body: Decodable> {

    public var wrappedValue: Optional<Body>

    public init() {
        wrappedValue = nil
    }

    public init(wrappedValue: Optional<Body>) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseErrorBody: Decodable {}
