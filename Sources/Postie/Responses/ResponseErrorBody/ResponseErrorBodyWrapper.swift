@propertyWrapper
public struct ResponseErrorBodyWrapper<Body: Decodable, BodyStrategy: ResponseErrorBodyDecodingStrategy> {
    /// The wrapped value representing the decoded error response body.
    ///
    /// This property holds the decoded error response body that is managed by this property wrapper.
    public var wrappedValue: Body?

    /// Initializes a new instance of `ResponseErrorBodyWrapper` with a nil value.
    ///
    /// Example usage:
    /// ```
    /// @ResponseErrorBodyWrapper var errorResponseBody: MyErrorResponseType?
    /// ```
    public init() {
        self.wrappedValue = nil
    }

    /// Initializes a new instance of `ResponseErrorBodyWrapper` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the decoded error response body.
    ///
    /// Example usage:
    /// ```
    /// @ResponseErrorBodyWrapper var errorResponseBody: MyErrorResponseType? = MyErrorResponseType()
    /// ```
    public init(wrappedValue: Body?) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: Decodable

extension ResponseErrorBodyWrapper: Decodable {
    public init(from decoder: Decoder) throws {
        guard let responseDecoder = decoder as? ResponseDecoding else {
            self.wrappedValue = try Body(from: decoder)
            return
        }
        guard BodyStrategy.isError(statusCode: responseDecoder.response.statusCode) else {
            self.wrappedValue = nil
            return
        }
        self.wrappedValue = try responseDecoder.decodeBody(to: Body.self)
    }
}
