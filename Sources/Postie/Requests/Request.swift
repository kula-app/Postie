/// Protocol used to define a response type to a given request type.
///
/// The `Request` protocol is used to define a response type for a given request type.
/// It requires conforming types to be encodable and to specify an associated type `Response`
/// that conforms to the `Decodable` protocol.
///
/// Example usage:
/// ```
/// struct MyRequest: Request {
///     typealias Response = MyResponse
///     // Implement the required properties and methods for the request
/// }
/// ```
public protocol Request: Encodable {
    /// The associated type representing the response type for the request.
    ///
    /// This associated type must conform to the `Decodable` protocol.
    associatedtype Response: Decodable
}
