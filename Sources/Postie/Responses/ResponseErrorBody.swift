@propertyWrapper
public struct ResponseErrorBody<Body: Decodable> {

    public var wrappedValue: Body?

    public init() {
        wrappedValue = nil
    }

    public init(wrappedValue: Body?) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseErrorBody: Decodable {

    public init(from decoder: Decoder) throws {
        guard let decoder = decoder as? ResponseDecoding else {
            self.wrappedValue = try Body(from: decoder)
            return
        }
        if (HTTPStatusCode.continue..<HTTPStatusCode.badRequest) ~= decoder.response.statusCode {
            self.wrappedValue = nil
            return
        }
        self.wrappedValue = try decoder.decodeBody(to: Body.self)
    }
}
