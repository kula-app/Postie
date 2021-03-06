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
        guard let responseDecoder = decoder as? ResponseDecoding else {
            wrappedValue = try Body(from: decoder)
            return
        }
        if (HTTPStatusCode.continue ..< HTTPStatusCode.badRequest) ~= responseDecoder.response.statusCode {
            wrappedValue = nil
            return
        }
        wrappedValue = try responseDecoder.decodeBody(to: Body.self)
    }
}
