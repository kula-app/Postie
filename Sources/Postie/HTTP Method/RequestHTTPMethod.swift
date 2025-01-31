@propertyWrapper
public struct RequestHTTPMethod: Encodable {
    /// The wrapped value representing the HTTP method.
    ///
    /// This property holds the `HTTPMethod` value that is managed by this property wrapper.
    public var wrappedValue: HTTPMethod

    /// Initializes a new instance of `RequestHTTPMethod` with the specified wrapped value.
    ///
    /// - Parameter wrappedValue: The wrapped value representing the HTTP method. Defaults to `.get`.
    ///
    /// Example usage:
    /// ```
    /// @RequestHTTPMethod var httpMethod: HTTPMethod = .post
    /// ```
    public init(wrappedValue: HTTPMethod = .get) {
        self.wrappedValue = wrappedValue
    }
}
