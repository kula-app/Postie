@propertyWrapper
public struct ResponseBodyWrapper<Body: Decodable, BodyStrategy: ResponseBodyDecodingStrategy> {
    /// The wrapped value representing the decoded response body.
    ///
    /// This property holds the decoded response body that is managed by this property wrapper.
    public var wrappedValue: Body?

    /// Initializes a new instance of `ResponseBodyWrapper` with a nil value.
    ///
    /// Example usage:
    /// ```
    /// @ResponseBodyWrapper var responseBody: MyResponseType?
    /// ```
    public init() {
        self.wrappedValue = nil
    }

    /// Initializes a new instance of `ResponseBodyWrapper` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the decoded response body.
    ///
    /// Example usage:
    /// ```
    /// @ResponseBodyWrapper var responseBody: MyResponseType? = MyResponseType()
    /// ```
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
