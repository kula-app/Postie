@propertyWrapper
public struct ResponseBodyWrapper<Body: Decodable, BodyStrategy: ResponseBodyDecodingStrategy> {
    public var wrappedValue: Body?

    public init() {
        self.wrappedValue = nil
    }

    public init(wrappedValue: Body?) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: Decodable

extension ResponseBodyWrapper: Decodable {
    public init(from decoder: Decoder) throws {
        guard let responseDecoder = decoder as? ResponseDecoding else {
            self.wrappedValue = try Body(from: decoder)
            return
        }
        guard BodyStrategy.validate(statusCode: responseDecoder.response.statusCode) else {
            self.wrappedValue = nil
            return
        }
        // Decoding empty data will fail, therefore check for status code based exemption
        if responseDecoder.data.isEmpty && BodyStrategy.allowsEmptyContent(for: responseDecoder.response.statusCode) {
            self.wrappedValue = nil
            return
        }
        self.wrappedValue = try responseDecoder.decodeBody(to: Body.self)
    }
}
