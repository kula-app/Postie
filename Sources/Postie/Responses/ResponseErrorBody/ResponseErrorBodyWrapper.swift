/// A property wrapper that wraps an error response body.
///
/// The `ResponseErrorBodyWrapper` property wrapper is used to wrap an error response body value.
/// It provides a `wrappedValue` property that holds the error response body value.
///
/// Example usage:
/// ```
/// @ResponseErrorBodyWrapper var errorResponseBody: MyErrorResponseType?
/// ```
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

/// Implements the `Decodable` protocol for `ResponseErrorBodyWrapper`.
extension ResponseErrorBodyWrapper: Decodable {
    /// Initializes a new instance of `ResponseErrorBodyWrapper` from a decoder.
    ///
    /// - Parameter decoder: The decoder to use for decoding the error response body.
    /// - Throws: An error if the decoder is not a `ResponseDecoding` instance or if the response body cannot be decoded.
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
