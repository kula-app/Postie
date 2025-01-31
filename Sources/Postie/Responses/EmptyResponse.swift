/// A struct representing an empty response.
///
/// The `EmptyResponse` struct is used to represent an empty response from an API.
/// It conforms to the `Decodable` protocol, allowing it to be decoded from an empty response body.
///
/// Example usage:
/// ```
/// @ResponseBody<EmptyResponse> var responseBody
/// ```
public struct EmptyResponse: Decodable {}
