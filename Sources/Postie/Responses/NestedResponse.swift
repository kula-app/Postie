/// A property wrapper that wraps a nested response.
///
/// To support inheritance, which can be especially useful for pagination, use the property wrapper `@NestedResponse` to add nested responses.
///
/// While decoding the flat HTTP response will be applied recursively to all nested responses, therefore it is possible, that different nested responses access different values of the original HTTP response.
///
/// **Example:**
///
/// ```swift
/// struct PaginatedResponse<NestedRequest: Request>: Decodable {
///
///     /// Header which indicates how many more elements are available
///     @ResponseHeader<DefaultHeaderStrategy> var totalElements
///
///     @NestedResponse var nested: NestedRequest
/// }
///
/// struct ListRequest: Request {
///
///     typealias Response = PaginatedResponse<ListResponse>
///
///     struct ListResponse: Decodable {
///         // see other examples
///     }
/// }
/// ```
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
