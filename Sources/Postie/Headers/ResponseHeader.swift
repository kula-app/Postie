/// A property wrapper that provides a convenient way to handle HTTP headers in a response.
///
/// The `ResponseHeader` struct is a property wrapper that allows you to decode HTTP headers from a response
/// using a specified decoding strategy. It wraps the `DecodingStrategy.RawValue` type and provides a default value.
///
/// Example usage:
/// ```
/// @ResponseHeader<CustomDecodingStrategy> var header: String
/// ```
@propertyWrapper public struct ResponseHeader<DecodingStrategy: ResponseHeaderDecodingStrategy> {
    /// The wrapped value representing the decoded header value.
    ///
    /// This property holds the `DecodingStrategy.RawValue` value that is managed by this property wrapper.
    public var wrappedValue: DecodingStrategy.RawValue

    /// Initializes a new instance of `ResponseHeader` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the decoded header value.
    ///
    /// Example usage:
    /// ```
    /// @ResponseHeader<CustomDecodingStrategy> var header: String = "value"
    /// ```
    public init(wrappedValue: DecodingStrategy.RawValue) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseHeader: Decodable where DecodingStrategy.RawValue: Decodable {
    /// Initializes a new instance of `ResponseHeader` by decoding from the given decoder.
    ///
    /// This initializer uses the specified decoding strategy to decode the header value from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if the decoding process fails.
    ///
    /// Example usage:
    /// ```
    /// let decoder = JSONDecoder()
    /// let header = try ResponseHeader<CustomDecodingStrategy>(from: decoder)
    /// ```
    public init(from decoder: Decoder) throws {
        wrappedValue = try DecodingStrategy.decode(decoder: decoder)
    }
}
