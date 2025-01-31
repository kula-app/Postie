@propertyWrapper
public struct NestedResponse<Response: Decodable> {
    /// The wrapped value representing the nested response.
    ///
    /// This property holds the nested response value that is managed by this property wrapper.
    public var wrappedValue: Response

    /// Initializes a new instance of `NestedResponse` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the nested response.
    ///
    /// Example usage:
    /// ```
    /// @NestedResponse var nestedResponse: MyResponseType
    /// ```
    public init(wrappedValue: Response) {
        self.wrappedValue = wrappedValue
    }
}

extension NestedResponse: Decodable {
    /// Initializes a new instance of `NestedResponse` by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if the decoding process fails.
    public init(from decoder: Decoder) throws {
        wrappedValue = try Response(from: decoder)
    }
}
